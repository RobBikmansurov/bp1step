class HomeController < ApplicationController

  def index
	  @usr = current_user if current_user
	  @uroles = @usr.user_business_role   # исполняет роли
  end

end
