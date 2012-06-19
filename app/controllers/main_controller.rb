class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'events'
  def my_events
    @events = Event.from_organizations_followed_by(current_user)
  end
  def all_events

  end
  def details

  end
end
