class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'events'

  def my_events
    session["events_url"] = my_events_url
    @events = Event.upcoming.from_organizations_followed_by(current_user)
    ensure_followed_organizations!
  end
  def my_events_calendar
    session["events_url"] = my_events_calendar_url
    if params[:year].nil? or params[:month].nil? or params[:day].nil?
      now = Time.now
      date = Time.new(now.year, now.month, now.day)
    else
      date = Time.new(params[:year], params[:month], params[:day])
    end
    @date_events = Event.from_organizations_followed_by(current_user).between(date, date)
    ensure_followed_organizations!
  end

  def all_events
    session["events_url"] = all_events_url

  end
  def all_events_calendar
    session["events_url"] = all_events_calendar_url

  end

  def details

  end
end
