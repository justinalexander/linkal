class SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def follow
    @venues = Venue.paginate(page: params[:page])
  end
  def organizations
    if current_user.followed_organizations.count == 0
      redirect_to follow_organizations_path
    end
  end
  def email

  end
  def account

  end
end
