class RenameClickToView < ActiveRecord::Migration
  def self.up
    rename_table "clicks", "views"
    change_table "views" do |t|
      t.rename "clickable_id", "viewable_id"
      t.rename "clickable_type", "viewable_type"
    end
  end

  def self.down
    change_table "views" do |t|
      t.rename "viewable_id", "clickable_id"
      t.rename "viewable_type", "clickable_type"
    end
    rename_table "views", "clicks"
  end
end
