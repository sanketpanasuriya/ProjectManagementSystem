class UsersController < ApplicationController
    before_action :checking_authenticity, only: %i[ new ]
    def index
        @users = User.all
        redirect_to "/"
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
          PasswordMailer.with(user: @user, password: @user.password).new_cridential_mail.deliver_later
          redirect_to '/'
        else
          render :new, status: :unprocessable_entity
        end

      end
    
      def edit
        @user = User.find(params[:id])

        params[:selected_value]=@user.roles.first.id
        render :file => 'public/403.html' unless can? :edit, @user

        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
      end
    
      def update
        @user = User.find(params[:id])
        old_role = @user.roles.first.name
        roles = params['user']['roles']
        params[:selected_value]=params['user']['roles']
        @roles =[]
        Role.select("id","name").all.each {|v| @roles << [v.name, v.id]}
        if current_user.has_role? 'admin'
          for role in @user.roles
            if role
              @user.roles.delete(role)
            end
          end
          @user.roles << Role.find(roles)
        end

        current_password = params['user']['current_password']
        current_password = current_password.blank? ? "": current_password


        if current_password != ""
          if @user.update_with_password(account_update_params_with_password)
            redirect_to action: "index" 
          else
            render :edit, status: :unprocessable_entity
          end
        elsif (current_user.roles.first.name == "admin" && params[:user][:id] != current_user.id)
          UserMailer.with(user: @user, old_role: old_role).role_changed.deliver_later
          redirect_to action: "index" 
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

        def checking_authenticity
          render :file => 'public/403.html' unless can? :new, User
        end
end
