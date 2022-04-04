class TaskController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_project
    before_action :set_task, only: %i[ edit show ]
    @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
    before_action :checking_authenticity_show, only: %i[ show index]
    before_action :checking_authenticity_edit, only: %i[ edit ]
    before_action :checking_authenticity_new, only: %i[ new create]
    def index
        @status = @@status
        @tasks = Task.joins(:sprint).where(sprint: {project_id: params[:project_id]}).order(created_at: :asc)
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
        @task = Task.new(task_params)
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        @employees = getEmployee
        @sprints = getSprint
        @status = @@status
        respond_to do |format|
            if @task.save
              format.html { redirect_to project_task_index_path, notice: "Task was successfully created." }
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
              format.html { redirect_to project_task_index_path(project_id: project_id), notice: "Task was successfully updated." }
              format.js
            else
              format.html { render :project_task_index_path, status: :unprocessable_entity }
            end
        end
    end

    def update_task_status
        @task = Task.find(params[:task][:id])
        status = params[:task][:status]
        @task.update(params.require(:task).permit(:id, :status))
        render :json => { data: "Success", status: @task.status}
    end

    def destroy

        @task =  Task.find(params[:id])
         if !( can? :destroy, @task)
            render :file => 'public/403.html'
            # return 
         else
            respond_to do |format|
                if @task.destroy
                    format.html { redirect_to project_task_index_path, notice: "Task was successfully destroyed." }
                else
                    format.html { render :new, status: :unprocessable_entity }
                end
            end
        end
           
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
