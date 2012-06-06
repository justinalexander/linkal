class AddCityToEvent < ActiveRecord::Migration
  
  def self.up
    add_column :events, :city_id, :integer
    add_index :events, :city_id
  end
  
  def self.down
    remove_column :events, :city_id
  end
  
end
