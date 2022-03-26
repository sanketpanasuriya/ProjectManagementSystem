class TaskController < ApplicationController
    @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
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
        # params[:task][:status] = "assigned"
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

        def task_params
            params.require(:task).permit(:title, :sprint_id, :user_id, :due_date, :status, :description)
        end

        def getEmployee(employees = [])
            User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|employee| employees << [employee.name, employee.id]}
            employees
        end
        def getSprint(sprints = [])
            Sprint.all.where(project_id: params[:project_id]).each {|sprint| sprints << [sprint.title, sprint.id]}
            sprints
        end
end
