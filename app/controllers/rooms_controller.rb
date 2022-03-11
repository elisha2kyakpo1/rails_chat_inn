class RoomsController < ApplicationController
  before_action :require_login

  def index
    @rooms = Room.all
    @users = User.all_except(@current_user)
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_param)

    respond_to do |format|
      if @room.save
        format.html { redirect_to message_url(@room), notice: 'room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @current_user = current_user
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
  
    render 'index'
  end

  private

  def room_param
    params.require(:room).permit(:name, :is_private)
  end
end
