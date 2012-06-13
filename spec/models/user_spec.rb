require 'spec_helper'

describe User do

  before do
    @user = FactoryGirl.create(:user)
  end
  subject {@user}

  describe "followed organizations" do

    let(:venue) { FactoryGirl.create(:venue)}
    before do
      @user.save
      @user.follow!(venue)
    end

    it {should be_following(venue)}
  end
end
