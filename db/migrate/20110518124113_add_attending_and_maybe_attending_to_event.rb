class AddAttendingAndMaybeAttendingToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :attending, :integer, :default => 0
    add_column :events, :maybe_attending, :integer, :default => 0

    Event.unscoped.each do |event|
      event.attending = 0
      event.maybe_attending = 0
      event.save!
    end
  end

  def self.down
    remove_column :events, :maybe_attending
    remove_column :events, :attending
  end
end
