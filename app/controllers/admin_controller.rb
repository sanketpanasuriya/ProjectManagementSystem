# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :is_admin?
  def soft_delete
    @user_id = params[:id]
    @user = User.find(@user_id)
    @user.delete_user = params[:isdelete] != 'false'

    if @user.save
      redirect_to action: 'alluser'
    else
      flash[:error_name] = 'Somthing wrong'
    end
  end

  def alluser
    @users = User.all
  end

  private

  def is_admin?
    render file: 'public/403.html' unless can? :manage, User
  end
end
