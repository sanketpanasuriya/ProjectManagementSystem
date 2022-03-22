class UsersCrudController < ApplicationController
    def index
        @users = User.all
      end
    
      def show
        @user = User.find(params[:id])
        
      end
    
      def new
        @user = User.new
        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
        
    end
    
      def create
        role = params['user']['roles']
        params[:selected_value]=params['user']['roles']
        params['user'].delete 'roles'
        @user = User.new(user_params)
        @user.roles << Role.find(role)
        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
    
        if @user.save
          redirect_to '/'
        else
          render :new, status: :unprocessable_entity
        end

      end
    
      def edit
        @user = User.find(params[:id])
        params[:selected_value]=@user.roles.first.id
        

        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
      end
    
      def update
        @user = User.find(params[:id])
        
        role = params['user']['roles']
        params[:selected_value]=params['user']['roles']
        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
       
        params['user'].delete 'roles'
        @user.roles << Role.find(role)
        if @user.update(account_update_params)
          redirect_to action: "index" 
        else
          render :edit, status: :unprocessable_entity
        end
      end
    
      def destroy
        @user = User.find(params[:id])
        user_list=User.with_user @user.name
        @user.destroy
        redirect_to action: "index" 
      end
    
      private
        def user_params
          params.require(:user).permit(:name,:email,:password,:password_confirmation,:roles)
        end
        def account_update_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation, :roles)
        end
end
