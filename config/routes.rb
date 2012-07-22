Socialatitude::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  protocol = Rails.env.production? ? 'https://' : 'http://'

  scope :protocol => protocol, :constraints => { :protocol => protocol } do
    devise_for :venues
    devise_for :users, :controllers => { :registrations => "registrations" } do
      get '/login' => 'devise/sessions#new'
      post '/login' => 'devise/sessions#create'
      get '/logout' => 'devise/sessions#destroy'
    end
  end

  match '/my-events' => 'main#my_events', :as => :my_events
  match '/my-events/calendar(/:year/:month/:day)' => 'main#my_events_calendar', :as => :my_events_calendar,
        :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
  match '/all-events' => 'main#all_events', :as => :all_events
  match '/all-events/calendar(/:year/:month/:day)' => 'main#all_events_calendar', :as => :all_events_calendar,
        :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}

  match 'about-us' => 'users#about', :as => :mobile_about
  match 'contact-info' => 'users#contact', :as => :mobile_contact

  match '/event-details/:id' => 'main#details', :as => :event_details

  match '/settings/organizations' => 'settings#organizations', :as => :settings_organizations
  match '/settings/account' => 'settings#account', :as => :settings_account
  match '/settings/follow_organizations' => 'settings#follow', :as => :follow_organizations

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

  resource :users do
    put :update_details, :update_password
  end
  resource :email_notifications, :only => [:edit, :update]
  resources :events do
    put :create_attendance, :on => :member
  end
  resources :user_organizations do
    put :company_only, :endorsed
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
  root :to => 'main#my_events'
end
