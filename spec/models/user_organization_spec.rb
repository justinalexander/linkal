require 'spec_helper'

describe "User Organizations" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @venue = FactoryGirl.create(:venue)

    @user_organization = @user.user_organizations.build(:venue_id => @venue.id)
  end

  it "should create a new instance given valid attributes" do
    @user_organization.save!
  end

  describe "follow methods" do
    before(:each) do
      @user_organization.save
    end

    it "should have a user attribute" do
      @user_organization.should respond_to(:user)
    end

    it "should have the right user" do
      @user_organization.user.should == @user
    end

    it "should have a venue attribute" do
      @user_organization.should respond_to(:venue)
    end

    it "should have the right followed venue" do
      @user_organization.venue.should == @venue
    end
  end
  describe "validations" do

    it "should require a user_id" do
      @user_organization.user_id = nil
      @user_organization.should_not be_valid
    end

    it "should require a venue_id" do
      @user_organization.venue_id = nil
      @user_organization.should_not be_valid
    end
  end
end
