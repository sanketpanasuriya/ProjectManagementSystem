class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :checking_authenticity, only: %i[edit update new destroy create]
  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  def show
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

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :client_id, :endingdate)
    end

    def checking_authenticity
      render :file => 'public/403.html' unless can? :manage, Project
    end
end
