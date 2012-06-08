Socialatitude::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  protocol = Rails.env.production? ? 'https://' : 'http://'

  scope :protocol => protocol, :constraints => { :protocol => protocol } do
    devise_for :venues
  end


  match '/dashboard' => 'dashboard#index', :as => :venue_root
  match '/dashboard/events' => 'dashboard#events', :as => :venue_events

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar,
        :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
  match '/calendar/:year/:month/:day' => 'calendar#day', :as => :day,
        :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}

  match '/events/:year/:month/:day' => 'events#index', :as => :events_for_day,
        :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
  match '/events/from/:from_year/:from_month/:from_day/to/:to_year/:to_month/:to_day' => 'events#index',
        :as => :events_between_dates,
        :constraints => { :from_year => /\d{4}/, :from_month => /\d{1,2}/, :from_day => /\d{1,2}/,
                          :to_year   => /\d{4}/, :to_month   => /\d{1,2}/, :to_day   => /\d{1,2}/ }
  resources :events do
    put :create_attendance, :on => :member
  end

  match '/contact' => 'high_voltage/pages#show', :id => 'contact', :as => 'contact'
  match '/about'   => 'high_voltage/pages#show', :id => 'about',   :as => 'about'
  match '/terms'   => 'high_voltage/pages#show', :id => 'terms',   :as => 'terms'

  get "/change_city" => 'cities#change_city'
  post "/change_city" => 'cities#change_city'
  get "/welcome" => 'welcome#step_1', :as => 'step_1'
  post "/welcome" => 'welcome#step_1', :as => 'step_1'
  post "/welcome/stay_in_touch" => 'welcome#step_2', :as => 'step_2'
  get "/welcome/stay_in_touch" => 'welcome#step_2', :as => 'step_2'
  get "/welcome/find_events" => 'welcome#step_3', :as => 'step_3'
  post "/welcome/find_events" => 'welcome#step_3', :as => 'step_3'
  
  #Keep the root url at the bottom of the routes file
  root :to => 'main#index'
end
