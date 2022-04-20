# frozen_string_literal: true

module UsersHelper
    def user_image(user)
        if(user.user_image?)
             return user.user_image_url
        else 
            return "/kgf.jpg"
        end  
    end
    def get_user_role(user)
        if(user.roles.first.name=="manager")
            '<span class="badge badge-pill badge-primary">Manager</span>'
             elsif (user.roles.first.name=="admin") 
            '<span class="badge badge-pill badge-danger">Admin</span>'
             elsif (user.roles.first.name=="customer") 
            '<span class="badge badge-pill badge-secondary">Customer</span>'
             else 
            '<span class="badge badge-pill badge-info">Employee</span>'
            end
    end
end
