class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate!, only: [:new, :create]
  before_action :owner_or_admin_access?, only: [ :edit, :update ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
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
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = (params[:id]) ? User.find(params[:id]) : current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end

    def owner_or_admin_access?
      redirect_to '/admin_access_required' if !@current_user.admin? || @current_user.id != @user.id
    end
end
