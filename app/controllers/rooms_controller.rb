class RoomsController < ApplicationController
  def index
    @rooms = Room.all
    @users = User.all_except(@current_user)
    @room = Room.new
  end

  def create
    @room = current_user.messages.build(room_param)

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
    @user = User.find(params[:id])
    @current_user = current_user
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
    @message = Message.new
    @room_name = get_name(@user, @current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render "rooms/index"
  end

  private

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def room_param
    params.require(:room).permit(:name, :is_private)
  end
end
