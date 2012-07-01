class UserOrganization < ActiveRecord::Base

  attr_accessible :venue_id, :follow_company_events, :follow_endorsed_events

  belongs_to :user
  belongs_to :venue

  validates :user_id, :presence  => true
  validates :venue_id, :presence  => true

  before_save :default_values

  private
    def default_values
      self.follow_company_events = true if self.follow_company_events.nil?
      self.follow_endorsed_events = true if self.follow_endorsed_events.nil?
    end

end
