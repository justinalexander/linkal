class AddLocationIdToEvents < ActiveRecord::Migration
  def self.up
    change_table "events" do |t|
      t.belongs_to "location"
      t.remove "address_1"
      t.remove "address_2"
      t.remove "city"
      t.remove "state"
      t.remove "zip"
      t.remove "location"
    end
  end

  def self.down
    change_table "events" do |t|
      t.remove "location"
      t.string "address_1"
      t.string "address_2"
      t.string "city"
      t.string "state"
      t.string "zip"
      t.string "location"
    end
  end
end
