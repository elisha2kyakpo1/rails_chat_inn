class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :pic) }
    devise_parameter_sanitizer.permit(:account_update) do |u|
 u.permit(:name, :email, :password, :current_password, :pic) end
  end
end
