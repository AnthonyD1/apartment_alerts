class ApplicationController < ActionController::Base
  before_action :initialize_guest_user
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_user
    super || guest_user
  end


  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def initialize_guest_user
    session[:guest_user_id] = create_guest_user.id if params[:guest].present?
  end

  def guest_user
    User.find(session[:guest_user_id]) if session[:guest_user_id].present?
  end

  def create_guest_user
    user = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    user.save(:validate => false)
    user
  end
end
