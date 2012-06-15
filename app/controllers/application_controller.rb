class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  before_filter :ensure_domain, :if => Proc.new { Rails.env.production? }

  helper :all

  APP_DOMAIN = 'www.socialatitude.com'

  # The default parameters of 0 and a "blank" city name indicate a the 
  # selection of "All Locations".
  def store_city(city_id = 0, city_name = "")
    session[:city_id] = city_id
    session[:city_name] = city_name
  end
  
  # Returns the current city. City is stored in session (chosen by user)
  # and if set, we retreive it.  A user can also choose "All Locations" 
  # specified by setting it to 0.
  def current_city
    if session[:city_id] && session[:city_id] != 0
      return City.find(session[:city_id])
    end
  end

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :user
      "users"
    else
      "application"
    end
  end

  private

  def ensure_domain
    if request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end

  def authenticate_venue_or_admin!
    return redirect_to new_venue_session_path unless venue_signed_in?
  end

  # Tell Devise to redirect after sign_in
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope.class.name
    when 'Venue'
      venue_root_url(:protocol => 'http')
    when 'Admin'
      admin_root_url(:protocol => 'http')
    else
      super
    end
  end

  def after_sign_up_path_for(resource)
    case resource
    when :User
      follow_organizations_url(:protocol => :http)
    else
      super
    end
  end

  # Tell Devise to redirect after sign_out
  def after_sign_out_path_for(resource_or_scope)
    root_url(:protocol => 'http')
  end
end
