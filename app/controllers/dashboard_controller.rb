class DashboardController < ApplicationController
  before_filter :authenticate_venue!

  def index
    @venue = current_venue
    @views = current_venue.views.count
    @next_event = current_venue.events.upcoming.first
  end

  def events
    @events = if params[:past].present?
                current_venue.events.past
              else
                current_venue.events.upcoming
              end.paginate(:per_page => params[:per_page] || Event.per_page, :page => params[:page])
  end

end
