require 'spec_helper'

describe Rails3::Plugin::Extender do
  describe '#extend_rails' do
    it "should extend i18n" do
      Rails3::Plugin::Extender.new do
        extend_rails :i18n do
          with MyAddition

          before :initialize do
            MyOtherAddition.say 'before localized!'
          end      

          before :configuration do
            MyOtherAddition.configured = 'was configured!'      
          end

          before :eager_load do
            puts "before eager load!"
          end
      
          after :initialize do
            MyAddition.say 'localized!'
          end      
        end
      end
    
      # Initialize the rails application
      Minimal::Application.initialize!        
      I18n.methods.grep(/zzz/).should_not be_empty

      MyAddition.heard.should == 'localized!'
      MyOtherAddition.heard.should == 'before localized!'
      MyOtherAddition.configured.should == 'was configured!'      
    end    
  end
end