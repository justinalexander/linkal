class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  has_many :user_organizations, :foreign_key => "user_id"

  has_many :followed_organizations, :through => :user_organizations,
                                    :source => :venue

  before_save :create_remember_token

  def follow!(venue)
    user_organizations.create!(venue_id: venue.id)
  end
  def unfollow!(venue)
    user_organizations.find_by_venue_id(venue.id).destroy
  end
  def following?(venue)
    user_organizations.find_by_venue_id(venue.id)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
