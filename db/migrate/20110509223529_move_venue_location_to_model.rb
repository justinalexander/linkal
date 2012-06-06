class Venue < ActiveRecord::Base
  belongs_to :location
end

class MoveVenueLocationToModel < ActiveRecord::Migration
  def self.up
    add_column "venues", "location_id", :integer

    Venue.all.each do |venue|
      location_attributes = venue.attributes.slice('location', 'phone', 'address_1', 'address_2', 'city', 'state', 'zip', 'country')
      location_attributes['name'] = location_attributes.delete('location')
      location = Location.create!(location_attributes)
      venue.location = location
      venue.save!
    end

  end

  def self.down
    remove_column "venues", "location_id"
  end
end
