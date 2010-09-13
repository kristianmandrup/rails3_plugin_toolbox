require 'rspec'
require 'rspec/autorun'
require 'r3_plugin_toolbox'

# See http://www.igvita.com/2010/08/04/rails-3-internals-railtie-creating-plugins/


# require 'active_record'
# require 'action_mailer'
# require 'active_support'
require 'action_controller'
require 'action_view'
require 'active_support/railtie'
# require 'rails/all'

module Minimal
  class Application < Rails::Application
    config.active_support.deprecation = :log
  end
end

module MyAddition
  def zzz
    'zzz'
  end

  class << self
    attr_accessor :heard
    
    def say message
      @heard = message
    end
  end
end

module MyOtherAddition
  def yyy
    'yyy'
  end

  class << self
    attr_accessor :heard
    attr_accessor :configured
    
    def say message
      @heard = message
    end
  end
end


RSpec.configure do |config|
end
