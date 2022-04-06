class TaskController < ApplicationController
    before_action :set_project,except:[:change_status]

    before_action :set_task, only: %i[ edit show ]
    @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
    before_action :checking_authenticity_show, only: %i[ show index]
    before_action :checking_authenticity_edit, only: %i[ edit ]
    before_action :checking_authenticity_new, only: %i[ new create]
    def index
        @status = @@status
        if params.has_key?(:sprint_id) 
            @tasks = Task.where(sprint_id: params[:sprint_id]).order(created_at: :asc)
        else
            @tasks = Task.joins(:sprint).where(sprint: {project_id: params[:project_id]}).order(created_at: :asc)
        end
        @hours={}
        @tasks.each do|x|
            
            task_h=Hour.find_by(task_id:x.id)
            if(task_h==nil)
                @hours[x.id]="Not Started"
            elsif(task_h.ending==nil)
                @hours[x.id]="On Going"
            else
                @hours[x.id]=((task_h.ending-task_h.starting)/ 1.hour).round(2)
            end
        end
        # sql="SELECT * FROM #{@tasks} LEFT JOIN Hour ON @tasks.id=Hour.task_id;"
        # p @tasks.left_outer_joins(:hours).select("@tasks.id,hours.starting")
        # p execute_statement(sql)
    end

    def show 
        @task = Task.find(params[:id])
    end

    def new
        @task = Task.new
        @employees = getEmployee
        @sprints = getSprint
        @status = @@status
    end

    def create
        flag= params.has_key?(:sprint_id)
        @task = Task.new(task_params)
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        @employees = getEmployee
        @sprints = getSprint
        @status = @@status
        respond_to do |format|
            if @task.save
              format.html { 
                if  flag
                    redirect_to project_sprint_task_index_path, notice: "Task was successfully created." 
                else
                    redirect_to project_task_index_path, notice: "Task was successfully created." 
                end
                }
            else
              format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    def edit
        # checking_authenticity_edit(:edit)
        @task = Task.find(params[:id])
        @employees = getEmployee
        @sprints = getSprint
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        params[:status_id] = @task.status
        @status = @@status
    end

    def update

        # checking_authenticity_edit(:update)
        @task = Task.find(params[:id])
    
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        params[:status_id] = @task.status
        @employees = getEmployee
        @sprints = getSprint
        @status = @@status
        project_id=params[:project_id]
        p @task
        respond_to do |format|
            if @task.update(task_params)
                # redirect_to (project_task_index_path) 
                # return
              format.html { 
                if params.has_key?(:sprint_id) 
                    redirect_to project_sprint_task_index_path(project_id: project_id, sprint_id: params[:sprint_id]), notice: "Task was successfully updated." 
                else
                    redirect_to project_task_index_path(project_id: project_id), notice: "Task was successfully updated." 
                end
              }
              format.js
            else
              format.html { 
                if params.has_key?(:sprint_id) 
                    render :project_sprint_task_index_path, status: :unprocessable_entity  
                else
                    render :project_task_index_path, status: :unprocessable_entity 
                end
                }
            end
        end
    end

    def destroy
        @task =  Task.find(params[:id])
        @project=@task.sprint.project
        if !( can? :destroy, @task)
            render :file => 'public/403.html' 
         else
                if @task.destroy
                        notice: "Task is deleted"
                        return render json: { respons_message: "Task is deleted"}
                   
                else
                    format.html { render :new, status: :unprocessable_entity }
                end
        end
           
    end
   # this method for AJAX call.it is use for status update
   def change_status
    json = JSON.parse request.body.read
        task=Task.find_by(id:json["id"])
        task.status=json["status"]

        task.save!        
        task_h=Hour.find_by(task_id:json["id"])

        # change hours variable calculate hours spend in task
        respons_message=""
        if(task_h==nil)
            respons_message="Not Started"
        elsif(task_h.ending==nil)
            respons_message="On Going"
        else
            respons_message=((task_h.ending-task_h.starting)/ 1.hour).round(2)
        end

        return render json: { respons_message: respons_message}
    end

    private 
        def set_project
            @project = Project.find(params[:project_id])
        end

        def set_task
            @task = Task.find(params[:id])
        end
        def task_params
            params.require(:task).permit(:title, :sprint_id, :user_id, :due_date, :status, :description)
        end

        def getEmployee(employees = [])
            User.joins(:roles).where(roles: {name: "employee"}, delete_user: false).select(:id, :name).each {|employee| employees << [employee.name, employee.id]}
            employees
        end
        def getSprint(sprints = [])
            Sprint.all.where(project_id: params[:project_id]).each {|sprint| sprints << [sprint.title, sprint.id]}
            sprints
        end

        def checking_authenticity_show
            render :file => 'public/403.html' unless can? :show, @project
        end

        def checking_authenticity_edit
            render :file => 'public/403.html' unless can? :edit, @task
        end

        def checking_authenticity_new
            render :file => 'public/403.html' unless can? :edit, @project
        end
        # this fot exicuting sql 
        def execute_statement(sql)
            results = ActiveRecord::Base.connection.execute(sql)
          
            if results.present?
              return results
            else
              return nil
            end
        end
end
