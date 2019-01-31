# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: :internal_server_error
  end
  include PublicActivity::StoreController
  # hide_action :current_user

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = 'Access' # exception.message
    redirect_to root_url
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def sort_direction
    params[:direction] || 'asc'
  end

  def sort_order
    sort_column + " " + sort_direction
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password])
    devise_parameter_sanitizer.permit(:update_avatar, keys: [:avatar])
  end

  def sort_order(column, direction)
    direction = direction.casecmp('asc').zero? ? 'asc' : 'desc'
    "#{column} #{direction}"
  end
end
