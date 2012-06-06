require 'spec_helper'

describe CalendarController do

  describe "GET day" do
    it "redirects to events day page" do
      get(:day, :year => 2011, :month => 5, :day => 4).should redirect_to(
        events_for_day_url('2011', '5', '4'))
    end
  end
  
  it "should redirect to step 3 if index is requested" do
    get :index
    response.should redirect_to(step_3_path)
  end
  
  describe "routing" do

    it "routes to calendar for different month" do
      { :get => "/calendar/2011/4" }.should route_to(
        :controller => "calendar", :action => "index", :year => "2011", :month => "4")
    end

    it 'routes to calendar for different day' do
      { :get => "/calendar/2011/4/5" }.should route_to(
        :controller => 'calendar', :action => 'day', :year => '2011', :month => '4', :day => '5' )
    end

  end

end

