class AddRefererToViews < ActiveRecord::Migration
  def self.up
    #create a text field because we don't know if a url will be longer than 255 characters or not.
    add_column :views, :http_referer, :text
  end

  def self.down
    remove_column :views, :http_referer
  end
end
