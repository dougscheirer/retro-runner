class OutstandingsController < ApplicationController
  before_action :logged_in
  skip_before_action :authenticate!, only: [ :index, :show ]
  before_action :set_outstanding, only: [:show, :edit, :update, :destroy]
  before_action :owner, only: [:edit, :destroy]

  def new
    @outstanding = Outstanding.new
    @outstanding.issue_id = params[:issue_id]
    @issue = Issue.find(@outstanding.issue_id)
    @outstanding.retro_id = @issue.retro_id
    @retro = Retro.find(@outstanding.retro_id)
    @outstanding.creator_id = current_user.id
  end

  def index
    @tasks = Outstanding.where("issue_id = #{params[:issue_id]}")
    @issue = Issue.find(params[:issue_id])
    @retro = Retro.find(@issue.retro_id)
  end

  def show
  end

  def create
    @outstanding = Outstanding.new(outstanding_params)
    @outstanding.issue_id = params[:issue_id]
    @issue = Issue.find(@outstanding.issue_id)
    @outstanding.retro_id = @issue.retro_id
    @retro = Retro.find(@outstanding.retro_id)
    @outstanding.creator_id = current_user.id
    respond_to do |format|
      if @outstanding.save
        flash[:success] = "Outstanding #{@outstanding.id} was successfully created"
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @outstanding }
      else
        flash[:error] = "invalid outstanding"
        format.html { redirect_to @retro }
        format.json { render json: @outstanding.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @outstanding.update(outstanding_params)
        flash[:success] = "Outstanding #{@outstanding.id} was successfully updated."
        format.html { redirect_to @retro }
        format.json { render :show, status: :ok, location: @outstanding }
      else
        flash[:error] = "invalid update"
        format.html { render :edit }
        format.json { render json: @outstanding.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @outstanding.destroy
    respond_to do |format|
      flash[:success] = "Outstanding #{@outstanding.id} was successfully destroyed."
      format.html { redirect_to @retro }
      format.json { head :no_content }
    end
  end

  private

  def set_outstanding
    @outstanding = Outstanding.find(params[:id])
    @issue = Issue.find(@outstanding.issue_id)
    @retro = Retro.find(@issue.retro_id)
  end

  def outstanding_params
    params.require(:outstanding).permit(:description, :assigned_to, :issue_id)
  end

  def logged_in
    redirect_to login_path if current_user.nil?
  end

  def owner
    redirect_to owner_access_required_path if (@outstanding.creator_id != @current_user.id && !@current_user.admin?)
  end

end
