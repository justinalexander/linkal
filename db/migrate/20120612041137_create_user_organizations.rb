class CreateUserOrganizations < ActiveRecord::Migration
  def self.up
    create_table :user_organizations do |t|
      t.integer :user_id
      t.integer :venue_id
      t.boolean :follow_company_event
      t.boolean :follow_endorsed_events

      t.timestamps
    end
  end

  def self.down
    drop_table :user_organizations
  end
end
