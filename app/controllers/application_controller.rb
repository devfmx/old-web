class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    authenticate_user!
    unless current_admin_user
      redirect_to new_user_session_path
    end  
  end

  def current_admin_user
    current_user && AdminUser.find_by_user_id(current_user)
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

end
