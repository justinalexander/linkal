class MainController < ApplicationController
  before_filter :authenticate_user!
  layout 'mobile'
  def index
  end
end
