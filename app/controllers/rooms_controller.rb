class RoomsController < ApplicationController
  before_action :require_login, except: %i[index]

  def index
    @rooms = Room.all
    @users = User.all_except(current_user)
    @room = Room.new
  end

  def create
    @room = Room.create(name: params["room"]["name"])
  end

  def show
    @current_user = current_user
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
  
    render 'index'
  end
end
