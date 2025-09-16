class Users::SessionsController < Devise::SessionsController
  def destroy
    current_user.update_column(:status, "offline") if current_user
    super
  end
end