class SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def follow
    @venues = Venue.paginate(page: params[:page])
  end
  def organizations
    ensure_followed_organizations!

    @data_url = params[:data_url]
    @organizations = current_user.organizations
  end

  def account

  end
end
