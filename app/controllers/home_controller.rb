# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @users = User.where(delete_user: false).all.paginate(page: params[:page], :per_page => 6)
    # .where(delete_user)    
  end
end
