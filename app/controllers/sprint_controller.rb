class SprintController < ApplicationController
  before_action :set_sprint, only: %i[ edit update destroy show]
  before_action :set_project, only: %i[new]
  before_action :checking_authenticity, only: %i[edit update destroy show]
  before_action :checking_authenticity_create, only: %i[new]
  def index
        
        @sprint = Sprint.all
      end
    
      def show
        @sprint=Sprint.find(params[:id])
      end
    
      def new
        project_id=params[:format]
        @sprint = Sprint.new
        @sprint.project_id=project_id

    end
    
    
      def edit
        @sprint = Sprint.find(params[:id])
        end
    
    
      def create
        temp=sprint_params
        temp["project_id"]=get_project
       
        @sprint = Sprint.new(temp)
        
        @project =Project.find(temp["project_id"])
  
        respond_to do |format|
          if @sprint.save
            format.html { redirect_to project_url(@project), notice: "Sprint was successfully created." }
            format.json { render :show, status: :created, location: @sprint }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @sprint.errors, status: :unprocessable_entity }
          end
        end
      end
    
      def update
        @sprint=Sprint.find(params[:id])
        @project =Project.find(params[:sprint][:project_id])
        respond_to do |format|
          if @sprint.update(sprint_params)
            format.html { redirect_to project_url(@project), notice: "Sprint was successfully updated." }
            format.json { render :show, status: :ok, location: @sprint }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @sprint.errors, status: :unprocessable_entity }
          end
        end
      end
    
      def destroy
       
        @sprint=Sprint.find(params[:id])
        @project=Project.find(@sprint.project_id)
        @sprint.destroy
        return render json: { respons_message: "Sprint is deleted"}
      end
    
      private
        def set_sprint
          @sprint = Sprint.find(params[:id])
        end
        def set_project
          @project = Project.find(params[:project_id])
        end
        def sprint_params
          params.require(:sprint).permit(:title, :description, :project_id, :expected_end_date)
        end
        def get_project
          params[:project_id]
        end
        def checking_authenticity
          render :file => 'public/403.html' unless can? :manage, @sprint
        end

        def checking_authenticity_create
          render :file => 'public/403.html' unless can? :edit, @project
        end
    
end
