class CreateClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.belongs_to :clickable, :polymorphic => true
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end
