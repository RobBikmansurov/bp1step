class HomeController < ApplicationController

  def index
	  if current_user
	  	@usr = current_user 
	  	@uroles = @usr.user_business_role   # исполняет роли
	  end
  end

end
