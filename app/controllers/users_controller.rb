class UsersController < ApplicationController
  def index
    @users = User.includes(:messages).search_data(params[:search])
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
    @friend_requests = @user.friend_requests
    @pending_friends = @user.pending_friends
    @friends = @user.friends

    @room = Room.new
    @rooms = Room.public_rooms
    @room_name = get_name(@user, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'rooms/index'
  end

  def create_friendship
    @user = User.find(params[:id])

    user_friendid = if current_user.id < @user.id
                      current_user.id.to_s + '-' + @user.id.to_s
                    else
                      @user.id.to_s + '-' + current_user.id.to_s
                    end
    friendship = current_user.create_friendship(@user.id, user_friendid)

    if friendship
      redirect_to rooms_path, notice: 'You successfully sent a friend request!'
    else
      redirect_to rooms_path, notice: 'Invalid Request!'
    end
  end

  def delete_friend
    @user = User.find(params[:id])

    user_friendid = if current_user.id < @user.id
                      current_user.id.to_s + '-' + @user.id.to_s
                    else
                      @user.id.to_s + '-' + current_user.id.to_s
                    end
    current_user.delete_friend(user_friendid)
    redirect_to root_path, notice: 'You successfully deleted friend!'
  end

  def confirm_friend
    @user = User.find(params[:id])
    current_user.confirm_friend(@user)
    redirect_to root_path, notice: 'You successfully accepted friend request!'
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
      redirect_to root_path,
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :pic, :search)
  end
end
