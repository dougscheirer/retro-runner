#require 'pusher'

#Pusher.app_id = '133467'
#Pusher.key = 'bec060895b93f6745a24'
#Pusher.secret = 'd3e13b0e84b33a44613a'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate!

  include SessionsHelper

  helper_method :current_user
  helper_method :logged_in?
end


