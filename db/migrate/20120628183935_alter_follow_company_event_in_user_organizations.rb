class AlterFollowCompanyEventInUserOrganizations < ActiveRecord::Migration
  def self.up
    rename_column "user_organizations", "follow_company_event", "follow_company_events"
  end

  def self.down
    rename_column "events", "follow_company_events", "follow_company_event"
  end
end
