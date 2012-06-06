require 'spec_helper'

describe View do
  it "should create" do
    lambda {
      Factory :view, :viewable => Factory(:event)
    }.should change(View, :count).by(1)    
  end 
end