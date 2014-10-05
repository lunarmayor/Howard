class ListsController < ApplicationController
  respond_to :json
  
  def index
  	@lists = current_user.lists
  	respond_with @lists, root: false
  end

  def show
  	@list = current_user.lists.where(id: params[:id]).includes(:notes).first
  	respond_with @list, root: false
  end
end