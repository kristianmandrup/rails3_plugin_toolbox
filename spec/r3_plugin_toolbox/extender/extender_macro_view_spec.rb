require 'spec_helper'

require 'active_record'
require 'action_mailer'

module Helper
  module View
    module Panel
      def draw_panel
        'panel'
      end
    end
    
    module Window
      def draw_window
        'panel'
      end
    end

    module Button
      def draw_button
        'button'
      end
    end    

    module Form
      def draw_form
        'form'
      end
    end        
  end
end

describe Rails3::Plugin::Extender do
  describe '#extend_rails' do        

    before :each do 
      with_extension do        
        extend_rails :view do
          extend_from_module Helper::View, :panel, :window
          extend_with Helper::View::Button, Helper::View::Form          
        end        

        extend_rails :controller do
          extend_from_module Helper::View, :panel
        end        
      end

      with_configuration do |c|
        c.greeting = 'hello'
      end

      with_configuration do
        greeting = 'hello'
        say = 'max'
      end
      
      Rails3::Plugin::Extender.new do
        with_configuration do
          greeting = 'hello'
          say = 'max'
        end
      end
    end

    it "should extend Action View" do
      after_init :view do 
        Rails3.with_configuration do
          greeting = 'hello'
        end
        
        puts "View initialized!"
        
        :view.should be_extended_with Helper::View, :panel, :window, :button, :form
        :view.should_not be_extended_with Helper::View, :unknown

        lambda { :view.should be_extended_with Helper::View, :unknown }.should raise_error        
      end

      init_app_railties :minimal, :view
    end
  end
end