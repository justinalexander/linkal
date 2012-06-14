class AddDefaultAdminUser < ActiveRecord::Migration
  def self.up
    AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
  end

  def self.down
  end
end
