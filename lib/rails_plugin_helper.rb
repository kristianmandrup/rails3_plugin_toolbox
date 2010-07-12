module Rails
  module Plugin
    module Helper
      def extend module_name, category        
        extend! get_module(module_name), get_category(category)
      end

      protected

      def get_category
        case category
        when :controller
          :action_controller          
        when :view
          :action_view
        else
          raise ArgumentError, "The category #{category} was not recognized"
        end
      end

      def get_module module_name
        case module_name
        when Constant        
          module_name
        when String
          module_name.to_s.constantize
        else          
          raise ArgumentError, "#{module_name} could not be converted into a loaded module"        
        end
      end

      def extend! module_name, category
        ActiveSupport.on_load(category) do
          include module_name
        end        
      end
    end
  end
end
