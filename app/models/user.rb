class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :current_password, :remember_me, :weekly_email

  has_many :user_organizations, :foreign_key => "user_id"

  has_many :followed_organizations, :through => :user_organizations,
                                    :source => :venue

  before_save :default_values

  def follow!(venue)
    user_organizations.create!(venue_id: venue.id)
  end
  def unfollow!(venue)
    user_organizations.find_by_venue_id(venue.id).destroy
  end
  def following?(venue)
    user_organizations.find_by_venue_id(venue.id)
  end

  def organizations
    user_organizations.joins(:venue).includes(:venue).order(:organization_name)
  end
  protected
    def password_required?
      self.new_record?
    end
  private
    def default_values
      self.weekly_email = true if self.weekly_email.nil?
    end
end
