class AddAttributesToEvent < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.string  "type"
      t.decimal "cost"
      t.text    "description"
      t.boolean "show_in_calendar", :default => false

      t.string  "address_1"
      t.string  "address_2"
      t.string  "city"
      t.string  "state"
      t.string  "zip"
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove  "type"
      t.remove  "cost"
      t.remove  "description"
      t.remove  "show_in_calendar"

      t.remove  "address_1"
      t.remove  "address_2"
      t.remove  "city"
      t.remove  "state"
      t.remove  "zip"
    end
  end
end
