class ApplicationController < ActionController::Base
  protect_from_forgery

  include PublicActivity::StoreController
  hide_action :current_user

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access"#exception.message
    redirect_to root_url
  end

end
