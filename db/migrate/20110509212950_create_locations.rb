class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string "name"
      t.string "phone"
      t.string "address_1"
      t.string "address_2"
      t.string "city"
      t.string "state"
      t.string "zip"
      t.string "country"

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
