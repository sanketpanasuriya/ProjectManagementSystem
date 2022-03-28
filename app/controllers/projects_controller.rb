class ProjectsController < ApplicationController
  before_action :set_project, only: %i"[ show edit update destroy]"
  before_action :set_project_by_format, only: %i[project_status]
  before_action :checking_authenticity_update, only: %i[edit update destroy]
  before_action :checking_authenticity_show, only: %i[show]
  before_action :checking_authenticity_status, only: %i[ project_status ]
  before_action :checking_authenticity_new, only: %i[new create]
  # GET /projects or /projects.json
  def index
    if current_user.has_role? 'employee'
      arr = Task.select(:sprint_id).where(user_id: current_user.id).map {|x| x.sprint_id}.uniq
      @projects = Project.joins(:sprints).where(sprints: {id: arr})
      return @projects
    end
    @projects = Project.all
  end

  def show
    project_id=params[:id]
    @sprint=Sprint.where(project_id: project_id).all
  end

  def new
    @client =[]
    User.joins(:roles).where(roles: {name: "customer"}).select(:id, :name).each {|v| @client << [v.name, v.id]}
    @project = Project.new
  end


  def edit
    @project = Project.find(params[:id])
    params[:selected_value]=@project.client_id
    @client = []
    User.joins(:roles).where(roles: {name: "customer"}).select(:id, :name).each {|v| @client << [v.name, v.id]}
  end


  def create
    @project = Project.new(project_params)
    @project.creator_id = current_user.id
    @project.status = "Created"
    params[:selected_value]=@project.client_id
    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def review_rating
    @project=Project.find(params[:format])
  end

  def save_review_rating
    
    @project=Project.find(params[:project][:id])
    respond_to do |format|
      if @project.update(project_params_review)
        format.html { redirect_to project_url(@project), notice: "Thank You for Rating" }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @project.destroy
   respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def project_status
    @project=Project.find(params[:format])
    @project.status=params[:status]=="true" ? "completed" : "ongoing"
    if(@project.save)
      redirect_to action: "show", id: @project
    end
end

  private
  
    def set_project
      @project = Project.find(params[:id])
    end

    def set_project_by_format
      @project = Project.find(params[:format])
    end

    def project_params
      params.require(:project).permit(:name, :description, :client_id, :endingdate)
    end

    def checking_authenticity_show
        render :file => 'public/403.html' unless can? :show, @project
    end

    def checking_authenticity_update
      render :file => 'public/403.html' unless can? :update, @project
  end

    def checking_authenticity_status
      render :file => 'public/403.html' unless can? :project_status, @project
    end

    def checking_authenticity_new
      render :file => 'public/403.html' unless can? :new, Project
    end
  
    def project_params_review
      params.require(:project).permit(:reviews, :rating)
    end
end
