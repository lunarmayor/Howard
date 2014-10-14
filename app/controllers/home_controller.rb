class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
  	gon.phone = current_user.phone
  end
end
