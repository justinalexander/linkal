class SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def follow
    @venues = Venue.paginate(page: params[:page])
  end
  def organizations
    ensure_followed_organizations!

    @venues = Venue.from_organizations_followed_by current_user
  end

  def account

  end
end
