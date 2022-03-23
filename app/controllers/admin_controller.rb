class AdminController < ApplicationController
    def soft_delete
        @user_id=params[:id]
        @user=User.find(@user_id)
        @user.delete_user=params[:isdelete]=='false'? false :true
       
        if(@user.save)
            redirect_to action: "alluser"
        else
            flash[:error_name]="Somthing wrong"
        end

    end
    def alluser
        @users = User.all
    end
    
end
