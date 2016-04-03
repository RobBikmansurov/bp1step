class ApplicationController < ActionController::Base
  
  include PublicActivity::StoreController
  hide_action :current_user

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access"#exception.message
    redirect_to root_url
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
    devise_parameter_sanitizer.for(:update_avatar) { |u| u.permit(:avatar) }
  end

end
