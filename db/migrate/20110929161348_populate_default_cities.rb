class PopulateDefaultCities < ActiveRecord::Migration
  def self.up
    davidson = City.find_or_create_by_name("Davidson")
    City.find_or_create_by_name("Cornelius")
    
    Event.unscoped.update_all(:city_id => davidson.id)
  end

  def self.down
    City.destroy_all #will nullify the city_id field automatically 
  end
end
