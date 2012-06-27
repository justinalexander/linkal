class AddBusinessRelationToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :business_relation, :integer
  end

  def self.down
    remove_column :events, :business_relation
  end
end
