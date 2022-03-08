class RoomsController < ApplicationController
  def index
    @rooms = Room.all
    @users = User.all_except(current_user)
  end

  def create; end

  def show; end
end
