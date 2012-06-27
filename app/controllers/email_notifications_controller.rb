class EmailNotificationsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    render :template => 'settings/email_notifications', :layout =>  'settings'
  end

  def update
    current_user.update_attributes(:weekly_email => params[:user][:weekly_email])
    render :template => 'settings/email_notifications', :layout =>  'settings'
  end
end
