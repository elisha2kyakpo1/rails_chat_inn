class Users::SessionsController < Devise::SessionsController
  def destroy
    current_user.update_column(:status, "offline") if current_user
    super
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password]) # assumes you use has_secure_password
      session[:user_id] = user.id
      user.update_column(:status, "online")   # ✅ set online when logging in
      redirect_to root_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Invalid email/password"
      render :new
    end
  end

  def destroy
    if current_user
      current_user.update_column(:status, "offline")  # ✅ set offline when logging out
      session[:user_id] = nil
    end
    redirect_to root_path, notice: "Logged out!"
  end

end