require 'pusher'

Pusher.app_id = '133467'
Pusher.key = 'bec060895b93f6745a24'
Pusher.secret = 'd3e13b0e84b33a44613a'


class RetrosController < ApplicationController
  before_action :logged_in
  before_action :set_retro, only: [ :show, :edit, :update, :destroy, :transition_status, :increment_discussed_review, :increment_discussed_followup ]
  before_action :set_project, only: [ :index ]
  skip_before_action :authenticate!, only: [ :index, :show ]
  before_action :admin_access?, only: [ :destroy ]

  # GET /retros
  # GET /retros.json
  def index
    @retros = Retro.where("project_id = #{params[:project_id]}").order("meeting_date DESC")
  end

  # GET /retros/1
  # GET /retros/1.json
  def show
    redirect_to retro_issues_path(@retro)
  end

  # GET /retros/new
  def new
    @retro = Retro.new
    @retro.project_id = params[:project_id]
    @time = Time.current
    if @time.month == 4 && @time.day == 1
      @retro.good_icon = 100
      @retro.meh_icon = 100
      @retro.bad_icon = 100
    else
      @retro.good_icon = rand(41)
      loop do
        @retro.meh_icon = rand(41)
        break if @retro.meh_icon != @retro.good_icon
      end
      loop do
        @retro.bad_icon = rand(41)
        break if @retro.bad_icon != @retro.good_icon && @retro.bad_icon != @retro.meh_icon
      end
    end
  end

  # GET /retros/1/edit
  def edit
  end

  # POST /retros
  # POST /retros.json
  def create
    @retro = Retro.new(retro_params)
    @retro.creator_id = current_user.id
    @retro.project_id = params[:project_id]
    @retro.meeting_date = Date.today
    @retro.status = "not_started"
    @time = Time.new
    if @time.month == 4 && @time.day == 1
      @retro.good_icon = 100
      @retro.meh_icon = 100
      @retro.bad_icon = 100
    else
      @retro.good_icon = rand(41)
      loop do
        @retro.meh_icon = rand(41)
        break if @retro.meh_icon != @retro.good_icon
      end
      loop do
        @retro.bad_icon = rand(41)
        break if @retro.bad_icon != @retro.good_icon && @retro.bad_icon != @retro.meh_icon
      end
    end
    respond_to do |format|
      if @retro.save
        flash[:success] = "Retro #{@retro.id} was successfully created."
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @retro }
        Pusher.trigger('retro_channel', 'new-retro-event', {retro: @retro, user: current_user, date: @retro.meeting_date.strftime("%F") })
      else
        flash[:error] = @retro.errors
        format.html { render :new }
        format.json { render json: @retro.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /retros/1/status/adding_issues
  def transition_status
    # TODO: make sure the transition is valid
    status = params[:status]
    if (Retro.statuses[status] == Retro.statuses[:restart])
      @retro.not_started!
    else
      @retro.status = status
    end
    if (@retro.status == "voted_review" && Issue.where("retro_id = #{@retro.id}").exists?)
      @issues = Issue.where("retro_id = #{@retro.id}").order('votes_count DESC')
      @retro.discussed_type = Issue.where("retro_id = #{@retro.id}").order('votes_count DESC')[0].type_to_int
    else
      @issues = Issue.where("retro_id = #{@retro.id}").sort_by{|issue| issue.type_to_int}
      if !@issues.empty?
        @retro.discussed_type = @issues[0].type_to_int
      end
    end
    @retro.discussed_index = 0
    if @retro.status == "voted_review"
      @last_retro_index = (Retro.where("project_id = #{@retro.project_id}").order('meeting_date DESC').index @retro)-1
      @last_retro = Retro.where("project_id = #{@retro.project_id}").order('meeting_date DESC')[@last_retro_index]
      if !@last_retro.nil?
        @further_tasks = Outstanding.where("retro_id = #{@last_retro.id} AND !complete")
      end
    end
    @retro.save!
    redirect_to retro_issues_path(@retro)
    Pusher.trigger('retro_channel', 'transition-retro-status-event', @retro.id)
  end

  # PATCH/PUT /retros/1
  # PATCH/PUT /retros/1.json
  def update
    respond_to do |format|
      if @retro.update(retro_params)
        flash[:success] = "Retro #{@retro.id} was successfully updated."
        format.html { redirect_to @retro }
        format.json { render :show, status: :ok, location: @retro }
      else
        flash[:error] = @retro.errors
        format.html { render :edit }
        format.json { render json: @retro.errors, status: :unprocessable_entity }
      end
    end
  end

  def increment_discussed_review
    @num_passed = 0
    loop do
      break unless Issue.where("retro_id = #{@retro.id}").exists?
      if @retro.discussed_type.nil? || @num_passed >= 3
        @retro.discussed_type = Issue.where("retro_id = #{@retro.id}").sort_by{|issue| issue.type_to_int}[0].type_to_int
        @retro.discussed_index = 0
      elsif @retro.discussed_type == 2
        @retro.discussed_type = 0
        @retro.discussed_index += 1
        @num_passed = 0
      else
        @retro.discussed_type += 1
      end
      break unless Issue.where("retro_id = #{@retro.id} AND issue_type = '#{@retro.int_to_type}'").size <= @retro.discussed_index
      @num_passed += 1
    end
    @retro.save!
    respond_to do |format|
      format.html { redirect_to retro_issues_path(@retro) }
      format.json { render json: {index: @retro.discussed_index, type: @retro.int_to_type}, status: :ok}
      Pusher.trigger('retro_channel', 'next-review-event', {index: @retro.discussed_index, type: @retro.int_to_type})
    end

  end

  def increment_discussed_followup
    @issues = Issue.where("retro_id = #{params[:id]}").order('votes_count DESC')
    @good_issues = Issue.where("retro_id = #{params[:id]} AND issue_type = 'Good'").order('votes_count DESC')
    @meh_issues = Issue.where("retro_id = #{params[:id]} AND issue_type = 'Meh'").order('votes_count DESC')
    @bad_issues = Issue.where("retro_id = #{params[:id]} AND issue_type = 'Bad'").order('votes_count DESC')
    if @issues.exists?
      @issue_types = { "Good" => @good_issues, "Meh" => @meh_issues, "Bad" => @bad_issues }
      @location = @issues.index @issue_types[@retro.int_to_type][@retro.discussed_index]
      if @location.nil?
        @location = @issue_types[@retro.int_to_type].size-1
      end
      @location+=1
      if @issues[@location].nil?
        @retro.discussed_type = @issues[0].type_to_int
        @retro.discussed_index = 0
      else
        @retro.discussed_type = @issues[@location].type_to_int
        @discussed_type_array = @issue_types[@issues[@location].issue_type]
        @retro.discussed_index = @discussed_type_array.index @issues[@location]
      end
    end
    @retro.save!
    respond_to do |format|
      format.html { redirect_to retro_issues_path(@retro) }
      format.json { render json: {index: @retro.discussed_index, type: @retro.int_to_type}, status: :ok}
      Pusher.trigger('retro_channel', 'next-voted-review-event', {index: @retro.discussed_index, type: @retro.int_to_type})
    end
  end

  # DELETE /retros/1
  # DELETE /retros/1.json
  def destroy
    @retro.destroy
    respond_to do |format|
      flash[:success] = "Retro #{@retro.id} was successfully destroyed."
      format.html { redirect_to project_retros_path(@retro.project_id) }
      format.json { head :no_content }
      Pusher.trigger('retro_channel', 'delete-retro-event', @retro.id)
    end
  end

  private
    # Use callbacks to share common setup or constraints between outstandings.
    def set_retro
      @retro = Retro.find(params[:id])
      set_project
    end

    def set_project
      @project ||= Project.find(params[:project_id] || @retro.project_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_params
      params.require(:retro).permit(:meeting_date, :project_id, :status)
    end

    def logged_in
     redirect_to login_path if current_user.nil?
    end
end
