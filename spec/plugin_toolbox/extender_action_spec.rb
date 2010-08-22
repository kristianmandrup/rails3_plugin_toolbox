require 'spec_helper'

describe Rails3::PluginExtender do
  describe '#extend_rails' do
    it "should extend Action View" do
      extender = Rails3::PluginExtender.new
      
      extender.extend_rails :view do
        with MyAddition
      
        after :initialize do
          MyAddition.say 'view it!'
        end      
      end
    
      # Initialize the rails application
      Minimal::Application.initialize!    
    
      ActionView::Base.instance_methods.grep(/zzz/).should_not be_empty
    
      MyAddition.heard.should == 'view it!'
    end    
    
    it "should extend Action Controller" do
      Rails3::PluginExtender.new do
        extend_rails :controller do
          with MyAddition
      
          after :initialize do
            MyAddition.say 'control it!'
          end      
        end
      end
    
      # Initialize the rails application
      Minimal::Application.initialize!    
    
      ActionController::Base.instance_methods.grep(/zzz/).should_not be_empty
    
      MyAddition.heard.should == 'control it!'
    end    
    
    it "should extend Action Mailer" do
      Rails3::PluginExtender.new do
        extend_rails :mailer do
          with MyAddition
      
          after :initialize do
            MyAddition.say 'mail me!'
          end      
        end
      end
    
      # Initialize the rails application
      Minimal::Application.initialize!    
    
      ActionMailer::Base.instance_methods.grep(/zzz/).should_not be_empty
    
      MyAddition.heard.should == 'mail me!'
    end  
  end
end