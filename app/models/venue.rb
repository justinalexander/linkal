class Venue < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  CARD_TYPES = {
    'visa'              => 'Visa',
    'master'            => 'MasterCard',
    'discover'          => 'Discover',
    'american_express'  => 'American Express' }

  CATEGORIES = [ 
    { :name  => 'Restaurant/Bar/Club',
      :stub  => 'restaurant-bar-club',
      :price => 0.5 },
    { :name  => 'Public Municipality',
      :stub  => 'public-municipality',
      :extra => 'College, Town, Parks and Rec, Museum, etc.',
      :price => 0.5 },
    { :name  => 'Performing/Visual Arts',
      :stub  => 'performing-visual-art',
      :price => 0.5 },
    { :name  => 'Neighborhood',
      :stub  => 'neighborhood',
      :price => 0.5 },
    { :name  => 'Gym',
      :stub  => 'gym',
      :price => 0.5 },
    { :name  => 'Non-Profit Organization',
      :stub  => 'non-profit-organization',
      :price => 0.5 },
    { :name  => 'Corporation',
      :stub  => 'corporation',
      :price => 0.5 },
    { :name  => 'Major Venue',
      :stub  => 'major-venue',
      :extra => 'Arenas, Stadiums, Amphitheaters, etc.',
      :price => 0.5 },
    { :name  => 'Multi-Location Retail Store',
      :stub  => 'multi-location-retail-store',
      :price => 0.5 },
    { :name  => 'Independent Retail Store',
      :stub  => 'independent-retail-store',
      :extra => 'Coffee, Bookstore, etc.',
      :price => 0.25 },
    { :name  => 'Church',
      :stub  => 'church',
      :price => 0.25 } ]
  
  def self.valid_category_stubs
    CATEGORIES.map{ |c| c[:stub] }
  end

  def self.categories_for_select
    CATEGORIES.map{ |c|
      [ "#{c[:name]}#{c[:extra].present? ? " (#{c[:extra]})" : ''}",
        c[:stub] ] }
  end

  def self.category_for_stub(stub)
    CATEGORIES.detect{ |c| c[:stub] == stub }
  end

  validates_presence_of :first_name, :last_name, :organization_name, :location, :billing_location, :category
  validates_acceptance_of :terms_of_service
  validates_inclusion_of :category, :in => valid_category_stubs

  # Accessors so we don't store credit card number, only temporary (in memory
  # while we process them).
  attr_accessor :credit_card_number, :credit_card_verification_value, :manual_payment

  has_many :events
  belongs_to :location
  belongs_to :billing_location, :class_name => "Location", :foreign_key => "billing_location_id"
  has_many :custom_locations, :through => :events, :source => :location
  has_many :views, :through => :events
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :billing_location

  def name
    organization_name.nil? ? "#{first_name} #{last_name}" : organization_name
  end

  def balance
    self.views.count * self.price_per_view
  end

  def category_name
    Venue.category_for_stub(self.category)[:name]
  end

  def price_per_view
    Venue.category_for_stub(self.category)[:price]
  end

  def credit_card_company_name
    CARD_TYPES[credit_card_type]
  end

 def self.from_organizations_followed_by(user)
    followed_organizations_ids = "SELECT venue_id FROM user_organizations
                         WHERE user_id = :user_id"
    where("id IN (#{followed_organizations_ids})", user_id: user.id)
  end

  private

  def is_manual_payment?
    self.manual_payment.present?
  end

  def set_merchant_customer_id
    # generate a random 20 character ID for use at Authorize.Net
    # we'd use our own primary key, but it's not available until after we've saved
    self.merchant_customer_id = ActiveSupport::SecureRandom.hex(10)
  end

  def validate_customer_profile_on_create
    return true if credit_card_type == "test"
    response = GATEWAY.create_customer_profile(
      :profile => {
        :description          => name,
        :email                => email,
        :merchant_customer_id => merchant_customer_id } )
    self.customer_profile_id = response.authorization
    errors.add(:base, response.message) unless response.success?
  end

  def validate_customer_profile_on_update
    return true if credit_card_type == "test"
    response = GATEWAY.update_customer_profile(
      :profile => {
        :customer_profile_id  => customer_profile_id,
        :description          => name,
        :email                => email } )
    errors.add(:base, response.message) unless response.success?
  end

  def bill_to
    { :first_name => first_name,
      :last_name  => last_name,
      :address    => billing_location.address_1,
      :city       => billing_location.city,
      :state      => billing_location.state,
      :zip        => billing_location.zip,
      :country    => billing_location.country }
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :first_name         => first_name,
      :last_name          => last_name,
      :number             => credit_card_number,
      :verification_value => credit_card_verification_value,
      :month              => credit_card_expires_on.month,
      :year               => credit_card_expires_on.year )
  end

  def payment
    { :credit_card => credit_card }
  end

  def validate_credit_card
    return true if credit_card_type == "test"
    if credit_card.valid?
      # set fields determined by ActiveMerchant
      self.credit_card_display_number = credit_card.display_number
      self.credit_card_type           = credit_card.type
    else
      credit_card.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
    end
  end

  def validate_customer_payment_profile_on_create
    return true if credit_card_type == "test"
    if errors.empty? # don't create if preceeding validations have failed
      response = GATEWAY.create_customer_payment_profile(
        :customer_profile_id  => customer_profile_id,
        :payment_profile      => {
          :bill_to => bill_to,
          :payment => payment },
        :validation_mode => :test )
      self.customer_payment_profile_id = response.params['customer_payment_profile_id']
      errors.add(:base, response.message) unless response.success?
    end
  end

  def validate_customer_payment_profile_on_update
    return true if credit_card_type == "test"
    if errors.empty? # don't update if preceeding validations have failed
      response = GATEWAY.update_customer_payment_profile(
        :customer_profile_id  => customer_profile_id,
        :payment_profile      => {
          :bill_to                      => bill_to,
          :customer_payment_profile_id  => customer_payment_profile_id,
          :payment                      => payment },
        :validation_mode => :test )
      errors.add(:base, response.message) unless response.success?
    end
  end

end
