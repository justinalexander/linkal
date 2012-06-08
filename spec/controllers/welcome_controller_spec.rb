require 'spec_helper'

describe WelcomeController do
  let!(:city) { FactoryGirl.create(:city, :name => 'Atlanta') }
  
  it "routes root url to #step_1" do
      { :get => '/welcome'}.should route_to(:controller => "welcome", :action => "step_1")
  end
  
  it "goes to step 1 when a city is not already stored in session[:city_id]" do
    request.session[:city_id] = nil
    request.session[:city_name] = nil
    get :step_1
    response.should be_successful
    session[:welcome_step].should eql(1)
  end
  
  it "goes to the events index when session already exists on step 1" do
    request.session[:city_id] = city.id
    request.session[:city_name] = city.name
    get :step_1
    response.should be_redirect() 
  end
  
  it "stores city and step in session after step 1" do
    post :step_2, :city_id => city.id
    session[:city_id].should eql(city.id)
    session[:city_name].should eql(city.name)
    session[:welcome_step].should eql(2)
  end
  
  it "can skip step 2" do
    get :step_3
    session[:welcome_step].should eql(3)
  end
  
  it "can get email from step 2 and save to mailchimp" do
    pending "Implement https://www.pivotaltracker.com/story/show/19470983"
  end
end
