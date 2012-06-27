class AddOrganizationNameToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :organization_name, :string
  end

  def self.down
    remove_column :venues, :organization_name
  end
end
