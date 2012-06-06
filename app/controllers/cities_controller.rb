class CitiesController < ApplicationController
  
  def change_city
    unless params[:city_id].to_i.zero?
      city = City.find(params[:city_id]) 
      store_city(city.id, city.name)
    else
      store_city
    end
    redirect_to :back
  end
  
end
