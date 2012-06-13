class UserOrganizationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @venue = Venue.find(params[:user_organization][:venue_id])
    current_user.follow!(@venue)
    respond_to do |format|
      format.html { redirect_to :controller => "settings", :action => "follow" }
      format.js
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    current_user.unfollow!(@venue)
    respond_to do |format|
      format.html { redirect_to :controller => "settings", :action => "follow" }
      format.js
    end
  end
end
