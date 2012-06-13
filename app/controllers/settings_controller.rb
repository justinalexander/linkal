class SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def follow
    @venues = Venue.paginate(page: params[:page])
  end
end
