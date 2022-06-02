# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  add_flash_types :notice,:warning, :error, :info

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def add_flash_message(key,value)
    if(flash[key]==nil)
      flash[key]=[]
    end
    
    flash[key]<<value
  end
end
