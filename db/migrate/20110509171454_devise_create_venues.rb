class DeviseCreateVenues < ActiveRecord::Migration
  def self.up
    create_table(:venues) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :venues, :email,                :unique => true
    add_index :venues, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :venues
  end
end
