require 'pusher'

Pusher.app_id = '133467'
Pusher.key = 'bec060895b93f6745a24'
Pusher.secret = 'd3e13b0e84b33a44613a'

class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate!, only: [ :index, :show ]
  before_action :owner, only: [ :destroy, :edit ]
  respond_to :js

  def hello_world
    Pusher.trigger('retro_channel', 'my-event', {:message => 'hello world'})
  end

  # GET /issues
  # GET /issues.json
  def index
    @good_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Good'")
    @meh_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Meh'")
    @bad_issues = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = 'Bad'")
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

        format.html { redirect_to @retro }
        @index = Issue.where("retro_id = #{params[:retro_id]} AND issue_type = '#{@issue.issue_type}'").order('votes_count DESC').index @issue
        format.json { render json: {issue: @issue,
                                    retro: @retro,
                                    index: @index,
                                    creator_name: current_user.name,
                                    issue_type: @issue.type_to_int,
                                    method: "POST" } }
        Pusher.trigger('retro_channel', 'create-issue-event', {issue: @issue,
                                                         retro: @retro,
                                                         index: @index,
                                                         creator_name: current_user.name,
                                                         issue_type: @issue.type_to_int,
                                                         method: "POST" } )
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
        @index = Issue.where("retro_id = #{@issue.retro_id} AND issue_type = '#{@issue.issue_type}'").order('votes_count DESC').index @issue
        format.html { redirect_to @retro }
        format.json { render json: {issue: @issue,
                                    retro: @retro,
                                    index: @index,
                                    creator_name: current_user.name,
                                    issue_type: @issue.type_to_int,
                                    method: "PATCH" } }
        Pusher.trigger('retro_channel', 'update-issue-event', {issue: @issue,
                                                               retro: @retro,
                                                               index: @index,
                                                               creator_name: current_user.name,
                                                               issue_type: @issue.type_to_int,
                                                               method: "PATCH" } )
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
    @index = Issue.where("retro_id = #{@issue.retro_id} AND issue_type = '#{@issue.issue_type}'").order('votes_count DESC').index @issue
    @type = @issue.type_to_int
    @issue.destroy
    respond_to do |format|

      format.html { redirect_to @retro }
      format.json { render json: {index: @index, type: @type } }
      Pusher.trigger('retro_channel', 'delete-issue-event', {index: @index, type: @type })
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
      redirect_to owner_access_required_path if ((@issue.creator_id != @current_user.id) && !@current_user.admin?)
    end
end