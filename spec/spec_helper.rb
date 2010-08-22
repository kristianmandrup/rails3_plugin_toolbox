require 'rspec'
require 'rspec/autorun'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'rails3_plugin_toolbox'

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
