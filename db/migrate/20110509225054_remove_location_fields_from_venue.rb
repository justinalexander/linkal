class RemoveLocationFieldsFromVenue < ActiveRecord::Migration
  def self.up
    change_table :venues do |t|
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

  def self.down
    change_table :venues do |t|
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
end
