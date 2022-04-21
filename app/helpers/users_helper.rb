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
        total_project = Project.where(creator_id: user.id)
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

    def getTotalProjects(user)
        if(user.roles.first.name=="manager")
            total_project = Project.where(creator_id: user.id).count
            "<span class='badge badge-pill badge-warning'>#{total_project}</span>"
        elsif (user.roles.first.name=="admin") 
            total_project = Project.all.count
            "<span class='badge badge-pill badge-warning'>#{total_project}</span>"
        elsif (user.roles.first.name=="customer") 
            total_project = Project.where(client_id: user.id).count
            "<span class='badge badge-pill badge-warning'>#{total_project}</span>"
        else 
            total_project = Project.joins(sprints: :tasks).where("tasks.user_id = #{user.id}").uniq.count
            "<span class='badge badge-pill badge-warning'>#{total_project}</span>"
        end
    end
end
