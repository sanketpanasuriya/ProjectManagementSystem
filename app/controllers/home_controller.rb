class HomeController < ApplicationController
  def index
    @users = User.where(delete_user: false).all
    # .where(delete_user)    
  end
  
end
