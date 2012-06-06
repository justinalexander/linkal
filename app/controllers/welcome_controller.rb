class WelcomeController < ApplicationController
  
  layout 'welcome'
  
  #root_url, city selector
  #https://www.pivotaltracker.com/story/show/19476473
  def step_1
    return redirect_to(calendar_path) if session[:city_id].present? and session[:city_name].present?
    session[:welcome_step] = 1
  end
  
  #step 2 of welcome steps, gets email and saves it to mailchimp
  #https://www.pivotaltracker.com/story/show/19476505
  def step_2
    session[:welcome_step] = 2
    unless params[:city_id].to_i.zero?
      city = City.find(params[:city_id]) 
      store_city(city.id, city.name)
    end
  end
  
  #step 3 is the search for events step
  #submitting the form here goes to the event index/search results page
  #https://www.pivotaltracker.com/story/show/19471015
  def step_3
    if params[:email] 
      #send email to mailchimp
      Gibbon.new(MAIL_CHIMP_API_KEY).list_subscribe(:id => MAIL_CHIMP_DEFAULT_LIST_ID, :email_address => params[:email], :double_optin => false, :send_welcome => true)
    end
    session[:welcome_step] = 3   
  end
 
end
