class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      session[:author_id] = user.id
      redirect_to posts_path, notice: 'Logged in succussfully!'
    else
      render 'new', alert: @user.errors.full_messages.join('. ').to_s
    end
  end

  def logout_user
    session[:author_id] = nil
    redirect_to root_path, notice: 'Logged out succussfully!'
  end
end
