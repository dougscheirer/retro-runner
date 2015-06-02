module SessionsHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate!
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
end
