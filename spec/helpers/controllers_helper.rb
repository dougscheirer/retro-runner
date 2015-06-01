module ControllerHelpers
  def authenticate!
    true
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, :type => :controller
end