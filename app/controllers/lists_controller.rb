class ListsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json, :html
  
  def index
    gon.phone = current_user.phone
  	@lists = current_user.lists
  	respond_with(@lists, root: false) do |format|
      format.html{ render 'home/index' }
  	end
  end

  def show
    gon.phone = current_user.phone
  	@list = current_user.lists.where(id: params[:id]).includes(:notes).first
  	respond_with( @list, root: false) do |format|
      format.html { render 'home/index' }
  	end
  end

  def create
  	list = current_user.lists.create(list_params)

  	if list.save
      respond_with list, root: false
    end
  end

  def update
  	list = List.find(params[:id])
  	list.update(list_params)
  	respond_with list
  end

  def destroy
  	list = List.find(params[:id])
  	list.destroy()
  	respond_with status: :ok
  end

  def list_params
  	params.require(:list).permit(:name)
  end 
end