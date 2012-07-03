class AddIndustryAndNotAttendingInEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :industry, :string, :default => 0
    add_column :events, :not_attending, :integer, :default => 0
  end

  def self.down
    remove_column :events, :industry
    remove_column :events, :not_attending
  end
end
