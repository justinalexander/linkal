class UserOrganization < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue

  validates :user_id, :presence  => true
  validates :venue_id, :presence  => true
end
