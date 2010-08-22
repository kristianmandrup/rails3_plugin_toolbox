# See http://www.igvita.com/2010/08/04/rails-3-internals-railtie-creating-plugins/

# require 'active_support/railtie'
require 'rails/all'

module Minimal
  class Application < Rails::Application
    config.active_support.deprecation = :log
  end
end

