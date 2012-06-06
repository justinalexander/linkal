require 'spec_helper'

describe Location do
  let(:attrs) { Factory.attributes_for(:location) }

  it "should be creatable with valid attributes" do
    location = Location.new(attrs)
    location.should be_valid
  end

   %w(name phone address_1 city country).each do |required_attribute|
    it "should be invalid without #{required_attribute}" do
      invalid_attrs = attrs.dup
      invalid_attrs.delete(required_attribute.to_sym)
      location = Location.new(invalid_attrs)
      location.should_not be_valid
    end
  end

end
