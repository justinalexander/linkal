class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'events'
  def my_events
  end
  def all_events

  end
end
