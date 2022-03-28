class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]

  @@status = [['Created'],['On Going'], ['Submitted'], ['Re-Submitted'], ['Rejected'], ['Done']]
  @@type = [['Bug'],['Error']]

  # GET /issues or /issues.json
  def index
    @issues = Issue.all
  end

  # GET /issues/1 or /issues/1.json
  def show
    # @issue=Issue.where(project_id: project_id).all
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
    @employee = []
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}
    @status = @@status
    @type = @@type
  end

  # POST /issues or /issues.json
  def create
   
    @employee = []
    User.joins(:roles).where(roles: {name: "employee"}).select(:id, :name).each {|v| @employee << [v.name, v.id]}
   
    @status = @@status
    @type = @@type
    @issue = Issue.new(issue_params)
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
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:project_id, :title, :description, :issue_type, :status, :employee_id)
    end
end
