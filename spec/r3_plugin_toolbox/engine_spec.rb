require 'yaml'
require 'spec_helper'

describe Rails3::Engine do
  it "should create an engine" do
    Rails3::Engine.new :my_engine do |e|
      e.add_locales_dir 'my_locales'
      e.set_orm :active_record
    end
  
    # Initialize the rails application
    init_app_railties :minimal
    
    Rails.configuration.generators.options[:rails][:orm].should == :active_record    
    Minimal::Application.config.generators.options[:rails][:orm].should == :active_record    
  end     
end
