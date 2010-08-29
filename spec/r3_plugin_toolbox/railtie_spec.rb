require 'spec_helper'

describe Rails3::Plugin do
  describe '#rails3_plugin' do    
    it "should create a plugin" do
      Rails3::Engine.new :my_plugin do
        set_orm :active_record
      end
    
      # Initialize the rails application
      init_app_railties :minimal
    
      Minimal::Application.config.generators.orm.should == :active_record
    end     
  end
end