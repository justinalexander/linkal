require 'spec_helper'

describe DashboardController do
  render_views

  context "when not logged in" do
    describe "GET index" do
      it "should redirect to venue sign-in" do
        get :index
        response.should redirect_to(new_venue_session_url)
      end
    end
  end

  context "when logged in" do
    let(:venue){ Factory.create(:venue) }
    before{ sign_in venue }

    describe "GET index" do
      it "should render" do
        get :index
        response.should be_success
      end
    end

    describe "GET events" do
      it "should assign upcoming events to @events" do
        Factory.create(:event)
        Factory.create(:event, :venue => venue, :start_at => 1.day.ago)
        Factory.create(:event, :venue => venue, :start_at => 1.day.from_now)

        get :events
        assigns(:events).should have(1).event
        assigns(:events).first.venue.should eq(venue)
        assigns(:events).first.start_at.should be > Time.now
      end
    end

  end

end
