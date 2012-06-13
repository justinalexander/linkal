class UserOrganization < ActiveRecord::Base

  attr_accessible :venue_id

  belongs_to :user
  belongs_to :venue

  validates :user_id, :presence  => true
  validates :venue_id, :presence  => true
end
