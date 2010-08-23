require 'spec_helper'

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

describe Rails3::PluginExtender do
  describe '#extend_rails' do        

    before :each do 
      Rails3::PluginExtender.new do
        extend_rails :view do
          extend_from_module Helper::View, :panel, :window
          extend_with Helper::View::Button, Helper::View::Form          
        end        
      end
    end

    # after_init :view do |view|
    #   view.should be_extended_with Helper::View, :panel, :window, :button, :form
    # end

    
    it "should extend Action View" do
      after_init :view do
        puts "View initialized!"
        
        :view.should be_extended_with Helper::View, :panel, :window, :button, :form
        :view.should_not be_extended_with Helper::View, :unknown
        lambda { :view.should be_extended_with Helper::View, :unknown }.should raise_error
        
        # :view.should be_extended_with Helper::View, :unknown
      end

      init_app_railties :minimal, :view
    end
  end
end