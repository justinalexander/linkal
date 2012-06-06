class AddCategoryToVenue < ActiveRecord::Migration
  def self.up
    add_column :venues, :category, :string

    Venue.all.each{ |venue| venue.update_attributes!(:category => 'corporation') }
  end

  def self.down
    remove_column :venues, :category
  end
end
