class CalendarController < ApplicationController
  
  def index
    logger.debug "Deprecation Warning: This action needs to be destroyed.  Change references to calendar_url to step_3_path in the app."
    redirect_to step_3_path
  end

  def day
    redirect_to events_for_day_url(params[:year], params[:month], params[:day])
  end
  
end
