class OutstandingsController < ApplicationController
  before_action :logged_in

  def new
    @outstanding = Outstanding.new
    @outstanding.retro_id = params[:retro_id]
    @retro = Retro.find(params[:retro_id])
  end

  def create
    @outstanding = outstanding.new(outstanding_params)
    @outstanding.retro_id = params[:retro_id]
    #@outstanding.issue_id = params[:issue_id]
    @retro = Retro.find(params[:retro_id])
    respond_to do |format|
      if @outstanding.save
        flash[:success] = "Your outstanding was successfully created"
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
  end

  def destroy
  end

  private

  def outstanding_params
    params.require(:outstanding).permit(:description, :retro_id, :assigned_to)
  end

  def logged_in
    redirect_to login_path if current_user.nil?
  end

end
