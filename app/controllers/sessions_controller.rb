class SessionsController < ApplicationController
  skip_before_filter :authenticate!, only: [:new, :create]

  def new
    redirect_to projects_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      redirect_to(log_in(user) || projects_path)
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out @current_user
    redirect_to root_path
  end

end
