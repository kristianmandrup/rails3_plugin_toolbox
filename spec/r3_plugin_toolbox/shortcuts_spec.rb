require 'spec_helper'
require 'r3_plugin_toolbox/shortcuts'
require 'active_record'

describe 'Plugin shortcuts' do
  describe '#rails3_extensions' do    
    it "should extend Active Record" do
      rails3_extensions do
        extend_rails :AR do
          with MyAddition
      
          after :initialize do
            MyAddition.say 'record me!'
          end      
        end
      end
    
      # Initialize the rails application
      init_app_railties :minimal, :active_record
    
      ActiveRecord::Base.instance_methods.grep(/zzz/).should_not be_empty
    
      MyAddition.heard.should == 'record me!'
    end     
  end

  describe '#rails3_plugin' do    
    it "should create a plugin" do
      rails3_plugin :my_plug do
        set_orm :active_record
      end
    
      # Initialize the rails application
      init_app_railties :minimal
    
      Rails.configuration.generators.options[:rails][:orm].should == :active_record    
      Minimal::Application.config.generators.options[:rails][:orm].should == :active_record
    end     
  end

  describe '#rails3_engine' do    
    it "should create an engine" do
      rails3_engine :my_engine do
        set_orm :active_record
      end
    
      # Initialize the rails application
      init_app_railties :minimal
    
      Rails.configuration.generators.options[:rails][:orm].should == :active_record    
      Minimal::Application.config.generators.options[:rails][:orm].should == :active_record
    end     
  end
end