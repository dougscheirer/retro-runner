class OutstandingsController < ApplicationController
  before_action :logged_in
  before_action :set_outstanding, only: [:show, :edit, :update, :destroy]

  def new
    @outstanding = Outstanding.new
    @outstanding.retro_id = params[:retro_id]
    @retro = Retro.find(params[:retro_id])
  end

  def index
  end

  def show
  end

  def create
    @outstanding = Outstanding.new(outstanding_params)
    @outstanding.retro_id = params[:retro_id]
    #@outstanding.issue_id = params[:issue_id]
    @retro = Retro.find(params[:retro_id])
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
    @retro = Retro.find(@outstanding.retro_id)
  end

  def outstanding_params
    params.require(:outstanding).permit(:description, :retro_id, :assigned_to)
  end

  def logged_in
    redirect_to login_path if current_user.nil?
  end

end
