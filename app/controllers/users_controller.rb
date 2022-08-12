class UsersController < ApplicationController
  def index
    @users = User.includes(:messages)
  end

  def new
    @user = User.new
  end

  def search
    @users = if params[name_search].present?
               User.filter_by_user_name(params[:name_search])
             else
               []
             end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @users = User.all_except(current_user)

    @room = Room.new
    @rooms = Room.public_rooms
    @room_name = get_name(@user, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'rooms/index'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:author_id] = @user.id
      redirect_to rooms_path,
                  notice: "Hi #{@user.name}, you successfully Signed up!"
    else
      render 'new', notice: 'This name is taken!'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private

  def get_name(user1, user2)
    user = [user1, user2].sort
    "private_#{user[0].id}_#{user[1].id}"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
