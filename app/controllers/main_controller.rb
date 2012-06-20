class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'events'
  def my_events
    @events = Event.upcoming.from_organizations_followed_by(current_user)
    if current_user.followed_organizations.count == 0
      redirect_to follow_organizations_path
    end
  end
  def all_events

  end
  def details

  end
end
