class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate!, only: [ :index, :show ]
  before_action :owner, only: [ :destroy, :edit ]

  # GET /issues
  # GET /issues.json
  def index
    @good_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Good'")
    @meh_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Meh'")
    @bad_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Bad'")

    @max_issues = [@good_issues.size, @meh_issues.size, @bad_issues.size].max

    @retro = Retro.find(params[:retro_id])
    @project = Project.find(@retro.project_id)
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
    @issue.issue_type = params[:type]
    @retro = Retro.find(params[:retro_id])
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.retro_id = params[:retro_id]
    @issue.creator_id = current_user.id
    @retro = Retro.find(params[:retro_id])
    respond_to do |format|
      if @issue.save
        flash[:success] = "Issue #{@issue.id} was successfully created."
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @issue }
      else
        flash[:error] = @issue.errors
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        flash[:success] = "Issue #{@issue.id} was successfully updated."
        format.html { redirect_to @retro }
        format.json { render :show, status: :ok, location: @issue }
      else
        flash[:error] = @issue.errors
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      flash[:success] = "Issue #{@issue.id} was successfully destroyed."
      format.html { redirect_to @retro }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between outstandings.
    def set_issue
      @issue = Issue.find(params[:id])
      @retro = Retro.find(@issue.retro_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:retro_id, :issue_type, :creator_id, :description)
    end

    def owner
      redirect_to owner_access_required if @issue.creator_id != @current_user.id
    end
end
