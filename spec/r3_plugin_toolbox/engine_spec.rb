require 'spec_helper'

describe Rails3::Engine do
  describe '#rails3_engine' do    
    it "should create an engine" do
      Rails3::Engine.new :my_engine do
        set_orm :active_record
      end
    
      # Initialize the rails application
      init_app_railties :minimal
    
      Minimal::Application.config.generators.orm.should == :active_record
    end     
  end
end