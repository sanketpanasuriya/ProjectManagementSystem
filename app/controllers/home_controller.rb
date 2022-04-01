# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if(current_user.roles.first.name=="employee")
      redirect_to "/employee"
    end
    @users = User.where(delete_user: false).all.paginate(page: params[:page], :per_page => 6)
  end
  def employee
    curent_user_id=current_user.id
    @task_list=Task.where(user_id:curent_user_id,status:["Created","Rejected","On Going"]).order("due_date")
    @issue_list=Issue.where(employee_id:curent_user_id)
    p @task_list
    # p @issue_list
  end
end
