class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate!

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate!
    puts request.inspect
    puts request.methods
    session[:redirect_after_login] = request.original_url if !logged_in?
    redirect_to login_path if !logged_in?
  end

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    redirect_path = session[:redirect_after_login]
    session[:redirect_after_login] = nil
    redirect_path
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def log_out(user)
    session[:user_id] = nil
    @current_user = nil
  end

  def admin_access?
    @current_user && @current_user.admin
  end

  helper_method :current_user
  helper_method :logged_in?
end


