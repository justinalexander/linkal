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
    org = UserOrganization.find(params[:user_organization_id])
    org.update_attributes(:follow_endorsed_events => params[:user_organization][:follow_endorsed_events])

    data_url = "/settings/organizations"
    redirect_to :controller => "settings", :action => "organizations", :data_url => data_url
  end

  def company_only
    org = UserOrganization.find(params[:user_organization_id])
    org.update_attributes(:follow_company_events => params[:user_organization][:follow_company_events])

    data_url = "/settings/organizations"
    redirect_to :controller => "settings", :action => "organizations", :data_url => data_url
  end

end
