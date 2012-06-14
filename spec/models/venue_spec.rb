require 'spec_helper'

describe Venue do
  let(:attrs) { FactoryGirl.attributes_for(:venue, :credit_card_type => "visa").merge(:location_attributes => FactoryGirl.attributes_for(:location)).merge(:billing_location_attributes => FactoryGirl.attributes_for(:location)) }

  it "should be creatable with valid attributes" do
    mock_customer_response = mock("Authorize.net Response", :authorization => "12345", :success? => true)
    mock_customer_payment_response = mock("Authorize.net Response", :params => {'customer_payment_profile_id' => "12345"}, :success? => true)
    venue = Venue.new(attrs)
    venue.should be_valid
  end

  %w(first_name last_name location_attributes category).each do |required_attribute|
    it "should be invalid without #{required_attribute}" do
      mock_customer_response = mock("Authorize.net Response", :authorization => "12345", :success? => true)
      invalid_attrs = attrs.dup
      invalid_attrs.delete(required_attribute.to_sym)
      venue = Venue.new(invalid_attrs)
      venue.should_not be_valid
    end
  end

  it "should only allow valid category names" do
    mock_customer_response = mock("Authorize.net Response", :authorization => "12345", :success? => true)

    venue = FactoryGirl.build(:venue, attrs.merge(:category => 'bogus'))
    venue.should_not be_valid
  end

  describe "#balance" do
    let(:venue){ FactoryGirl.create(:venue) }
    let(:event){ FactoryGirl.create(:event, :venue => venue) }
    before{ 5.times{ event.record_view('127.0.0.1') } }

    it "should be able to calculate its balance" do
      venue.balance.should eq(2.5)
    end

    it "should include deleted events in balance calculation" do
      event.deleted = true
      event.save!

      venue.balance.should eq(2.5)
    end
  end

end
