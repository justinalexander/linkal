require 'spec_helper'

describe View do
  it "should create" do
    lambda {
      FactoryGirl.create :view, :viewable => FactoryGirl.create(:event)
    }.should change(View, :count).by(1)
  end 
end
