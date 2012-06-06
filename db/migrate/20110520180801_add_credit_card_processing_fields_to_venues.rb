class AddCreditCardProcessingFieldsToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :merchant_customer_id, :string
    add_column :venues, :customer_profile_id, :string
    add_column :venues, :customer_payment_profile_id, :string
    
    add_column :venues, :credit_card_expires_on, :date
    add_column :venues, :credit_card_display_number, :string
    add_column :venues, :credit_card_type, :string
    
    add_column :venues, :billing_location_id, :integer
  end

  def self.down
    remove_column :venues, :billing_location_id
    
    remove_column :venues, :credit_card_type
    remove_column :venues, :credit_card_display_number
    remove_column :venues, :credit_card_expires_on
    
    remove_column :venues, :customer_payment_profile_id
    remove_column :venues, :customer_profile_id
    remove_column :venues, :merchant_customer_id
  end
end