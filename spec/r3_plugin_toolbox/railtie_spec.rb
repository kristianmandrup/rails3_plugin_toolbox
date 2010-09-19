require 'spec_helper'

describe Rails3::Plugin do
  it "should create a railtie plugin" do
    Rails3::Plugin.new :my_plugin do |e|
      e.set_orm :active_record
    end
  
    # Initialize the rails application
    init_app_railties :minimal
    
    Rails.configuration.generators.options[:rails][:orm].should == :active_record    
    Minimal::Application.config.generators.options[:rails][:orm].should == :active_record    
  end     
end

