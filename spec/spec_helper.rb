require 'rspec'
require 'rspec/autorun'
require 'r3_plugin_toolbox'

# See http://www.igvita.com/2010/08/04/rails-3-internals-railtie-creating-plugins/


# require 'active_support'
require 'action_controller'
require 'action_view'
require 'active_support/railtie'
# require 'rails/all'

require 'fixtures/extension_modules'

module Minimal
  class Application < Rails::Application
    config.active_support.deprecation = :log
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
end
