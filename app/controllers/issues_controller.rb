class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]
  before_action :checking_authenticity_assign,only: %i[assign_issue_show assign_issue] 
  
  
  @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
  @@type = [['Bug'],['Error']]

  # GET /issues or /issues.json
  def index
    @project_id=params[:format]
    
    @issues = Issue.where(project_id: @project_id).all
  end

  # GET /issues/1 or /issues/1.json
  def show
    checking_authenticity(@issue,:show)
    @status = @@status
    @type = @@type
  end

  # GET /issues/new
  def new
    

    @status = @@status
    @type = @@type
    @employee = []
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}

    project_id=params[:format]
    
     @issue = Issue.new
     @issue.project_id = project_id
  end

  # GET /issues/1/edit
  def edit

    checking_authenticity(@issue,:edit)
    @employee = []
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}
    @status = @@status
    @type = @@type
    p @issue
  end

  # POST /issues or /issues.json
  def create
    
    checking_authenticity(Issue.new,:create)
   
    @employee = []
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}
   
    @status = @@status
    @type = @@type
    temp=issue_params
    temp["status"]="Created"
  
    @issue = Issue.new(temp)
    @issue.creator_id = current_user.id

    respond_to do |format|
      if @issue.save
        format.html { redirect_to issue_url(@issue), notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1 or /issues/1.json
  def update

    checking_authenticity(@issue,:update)
    @status = @@status
    @type = @@type
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to issue_url(@issue), notice: "Issue was successfully updated." }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy

    checking_authenticity(@issue,:destroy)
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def assign_issue_show
    issue_id=params[:format]
    @issue=Issue.find(issue_id)
    @employee = []
    params[:status_id]=@issue.status
    @status = @@status
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}
    if(@issue.employee_id!=nil)
      params[:selected_value]=@issue.employee_id
    end

  end
  def assign_issue
    @issue=Issue.find(params[:id])
    @issue["status"]=params["issue"]["status"]
    @issue["employee_id"]=params["issue"]["employee_id"]!=nil ?params["issue"]["employee_id"]:@issue["employee_id"]

    respond_to do |format|
      if @issue.save
        format.html { redirect_to issue_url(@issue), notice: "" }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
    
  end
  def my_issue
   
  project_id = params[:format]
  current_user_id=current_user.id

  @issues=Issue.where(employee_id: current_user_id , project_id: project_id ).all
  end
  private
    def checking_authenticity(issue,opration)

        render :file => 'public/403.html' unless can? opration, issue

    end 
    def checking_authenticity_assign
      @issue = Issue.find(params[:format])
      @project=Project.find(@issue.project_id)
      if(current_user.roles.first.name=="manager")
        
        render :file => 'public/403.html' unless can? :assign_issue, @project
      else 
        render :file => 'public/403.html' unless can? :assign_issue, @issue
        
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:project_id, :title, :description, :issue_type, :status)
    end
end
