class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate!, only: [:new, :create]
  before_action :owner_or_admin_access?, only: [ :edit, :update, :destroy ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
    @num_votes = 3
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_path = log_in @user
      flash[:success] = "Welcome to the RetroRunner!"
      redirect_to(redirect_path || @user)
    else
      @user.errors.each{|attr,msg|
        flash[:error] = "#{attr} - #{msg}"
      }
      render 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "User #{@user.id} was successfully updated."
        format.html { redirect_to users_path }
        format.json { render :show, status: :ok, location: @retro }
      else
        flash[:error] = @user.errors
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:success] = "User #{@user.name} was successfully destroyed."
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between outstandings.
    def set_user
      @user = (params[:id]) ? User.find(params[:id]) : current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end

    def owner_or_admin_access?
      redirect_to '/admin_access_required' unless (@current_user.admin? || @current_user.id == @user.id)
    end
end
