class UsersController < ApplicationController

  before_filter :authenticate_user!

  def update_details
    current_user.update_attributes(
      :first_name => params[:user][:first_name],
      :last_name => params[:user][:last_name],
      :email => params[:user][:email],
    )
    render :template => 'settings/account', :layout =>  'settings'

  end
  def update_password
    if current_user.update_with_password(params[:user])
      sign_in current_user, :bypass => true
    else
      flash[:error] = current_user.errors.empty? ? "Error" : current_user.errors.full_messages.to_sentence
    end

    render :template => 'settings/account', :layout =>  'settings'
  end
end
