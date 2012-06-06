require 'spec_helper'

describe CitiesController do
  before(:all) do
    @city1 = Factory :city, :name => "Davidson"
    @city2 = Factory :city, :name => "Atlanta"
  end
  context "POST change_city" do
    it "can change city session values to a city" do
      request.env["HTTP_REFERER"] = root_url
      post :change_city, :city_id => @city1.id
      session[:city_id].should eql(@city1.id)
      session[:city_name].should eql(@city1.name)
      
      post :change_city, :city_id => @city2.id
      session[:city_id].should eql(@city2.id)
      session[:city_name].should eql(@city2.name)
    end
    it "can change city session values to all locations" do
      request.env["HTTP_REFERER"] = root_url
      post :change_city, :city_id => "0"
      session[:city_id].should eql(0)
      session[:city_name].should eql("")
    end
  end
end

=begin
 def change_city
    unless params[:city_id].to_i.zero?
      city = City.find(params[:city_id]) 
      session[:city_id] = city.id
      session[:city_name] = city.name
    else
      session[:city_id] = 0
      session[:city_name] = ""
    end
    redirect_to :back
  end
   
=end
