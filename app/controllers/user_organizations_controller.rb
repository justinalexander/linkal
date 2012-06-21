class UserOrganizationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @venue = Venue.find(params[:user_organization][:venue_id])
    current_user.follow!(@venue)
    redirect_to :controller => "settings", :action => "follow"
  end

  def destroy
    @venue = UserOrganization.find(params[:id]).venue
    current_user.unfollow!(@venue)
    redirect_to :controller => "settings", :action => "follow"
  end

  def endorsed

  end

  def company_only

  end

end
