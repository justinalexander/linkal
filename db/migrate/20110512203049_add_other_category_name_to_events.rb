class AddOtherCategoryNameToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :other_category_name, :string

    Event.unscoped.each do |event|
      event.update_attributes!( :category => 'other', :other_category_name => event.category )
    end
  end

  def self.down
    Event.unscoped.each do |event|
      event.update_attributes!( :category => event.category_name )
    end
    remove_column :events, :other_category_name
  end
end
