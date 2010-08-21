require "spec_helper"

module MyControllerAddition
  def hello
    puts "Hello from MyControllerAddition"
  end
end

describe Rails::PluginToolbox do
  before(:each) do
    @controller_class = Class.new
    @controller = @controller_class.new
    stub(@controller).params { {} }
    mock(@controller_class).helper_method(:can?, :cannot?)    
    @extender = Rails::PluginToolbox::Extender.new
  end
  
  describe '#extend_rails' do
    @extender.extend_rails :controller do
      with MyModule
    end

    ActionController
    
  end
end 
