class AddWeeklyEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :weekly_email, :boolean
  end

  def self.down
    remove_column :users, :weekly_email
  end
end
