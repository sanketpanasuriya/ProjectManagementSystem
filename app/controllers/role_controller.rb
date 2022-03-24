# frozen_string_literal: true

class RoleController < ApplicationController
  before_action :checking_role
  def index
    @roles = Role.all
  end

  def show
    @role = Role.find(params[:id])
    redirect_to action: 'index'
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to @role
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])

    if @role.update(role_params)
      redirect_to @role
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role = Role.find(params[:id])
    user_list = User.with_role @role.name
    if user_list.empty?
      @role.destroy
    else
      flash[:error_name] = "You Can not delete #{@role.name} Role."

    end
    # p user_list.empty?

    redirect_to action: 'index'
  end

  private

  def role_params
    params.require(:role).permit(:name)
  end
  def  checking_role
      render :file => 'public/403.html' unless can? :manage, Role
  end
end
