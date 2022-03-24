class UsersController < ApplicationController
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
    
      def create_user
        role = params['user']['roles']
        params[:selected_value]=params['user']['roles']
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

        render :file => 'public/403.html' unless can? :update, @user


        params[:selected_value]=@user.roles.first.id
        

        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
      end
    
      def update
        @user = User.find(params[:id])
        
        roles = params['user']['roles']
        params[:selected_value]=params['user']['roles']
        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
       
        for role in @user.roles
          if role
            @user.roles.delete(role)
          end
        end
        @user.roles << Role.find(roles)

        current_password = params['user']['current_password']

        if current_password != ""
          demo = (@user.password == current_password)
          # raise demo
          if @user.update_with_password(account_update_params_with_password)
            redirect_to action: "index" 
          else
            render :edit, status: :unprocessable_entity
          end
        else
          if @user.update(account_update_params_without_password)
            redirect_to action: "index" 
          else
            render :edit, status: :unprocessable_entity
          end
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
          params.require(:user).permit(:name,:email,:password,:password_confirmation)
        end

        def account_update_params_with_password
          params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
        end

        def account_update_params_without_password
          params.require(:user).permit(:name, :email)
        end
end
