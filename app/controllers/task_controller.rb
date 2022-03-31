class TaskController < ApplicationController
    before_action :set_project
    before_action :set_task, only: %i[ edit show ]
    @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
    before_action :checking_authenticity_show, only: %i[ show index]
    before_action :checking_authenticity_edit, only: %i[ edit destroy]
    before_action :checking_authenticity_new, only: %i[ new create]
    def index
        @tasks = Task.joins(:sprint).where(sprint: {project_id: params[:project_id]})
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
        @task = Task.find(params[:id])
        @employees = getEmployee
        @sprints = getSprint
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        params[:status_id] = @task.status
        @status = @@status
    end

    def update
        @task = Task.find(params[:id])
        params[:sprint_id]=@task.sprint.id
        params[:employee_id] = @task.user_id
        params[:status_id] = @task.status
        @employees = getEmployee
        @sprints = getSprint
        @status = @@status

        respond_to do |format|
            if @task.update(task_params)
              format.html { redirect_to project_task_index_path, notice: "Task was successfully updated." }
            else
              format.html { render :project_task_index_path, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @task =  Task.find(params[:id])
        respond_to do |format|
            if @task.destroy
                format.html { redirect_to project_task_index_path, notice: "Task was successfully destroyed." }
            else
                format.html { render :new, status: :unprocessable_entity }
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

end
