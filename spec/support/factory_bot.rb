require_relative './controller_macros'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.extend ControllerMacros, :type => :controller
end
