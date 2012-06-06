class AddDeletedColumnForEvent < ActiveRecord::Migration
  def self.up
    add_column "events", "deleted", :boolean, :default => false

    Event.unscoped.each do |event|
      event.deleted = false
      event.save!
    end
  end

  def self.down
    remove_column "events", "deleted"
  end
end
