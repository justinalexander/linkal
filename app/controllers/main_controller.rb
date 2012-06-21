class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'events'

  def my_events
    set_events_url
    @events = Event.upcoming.from_organizations_followed_by(current_user)
    ensure_followed_organizations!
  end
  def my_events_calendar
    set_events_url
    set_current_date

    set_calendar_events_for Event.from_organizations_followed_by(current_user)

    ensure_followed_organizations!
  end

  def all_events
    set_events_url
    @events = Event.upcoming
    ensure_followed_organizations!
  end

  def all_events_calendar
    set_events_url
    set_current_date

    set_calendar_events_for Event

    ensure_followed_organizations!
  end

  def details

  end

  private
  def set_events_url
    session["events_url"] = url_for()
  end
  def set_current_date
    if params[:year].nil? or params[:month].nil? or params[:day].nil?
      now = Time.now
      @current_date = Time.new(now.year, now.month, now.day)
    else
      @current_date = Time.new(params[:year], params[:month], params[:day])
    end
  end
  def set_calendar_events_for events
    @date_events = events.between(@current_date.beginning_of_day, @current_date.end_of_day)
    @month_events = events.between(@current_date.beginning_of_month, @current_date.end_of_month)
  end
end
