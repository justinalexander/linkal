class AddAttributesToVenue < ActiveRecord::Migration
  def self.up
    change_table "venues" do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "location"
      t.string "phone"
      t.string "address_1"
      t.string "address_2"
      t.string "city"
      t.string "state"
      t.string "zip"
      t.string "country"
    end
  end

  def self.down
    change_table "venues" do |t|
      t.remove "first_name"
      t.remove "last_name"
      t.remove "location"
      t.remove "phone"
      t.remove "address_1"
      t.remove "address_2"
      t.remove "city"
      t.remove "state"
      t.remove "zip"
      t.remove "country"
    end
  end
end
