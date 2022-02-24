class UsersController < ApplicationController
  def index
    @users = User.includes(:messages)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @created_posts = @user.posts
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
      redirect_to posts_path,
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

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
