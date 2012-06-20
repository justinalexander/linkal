class SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def follow
    @venues = Venue.paginate(page: params[:page])
  end
  def organizations
    ensure_followed_organizations!
  end
  def email

  end
  def account

  end
end
