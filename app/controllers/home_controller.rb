class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index
  def index
  	gon.phone = current_user.phone
  end

  def splash
  end
end
