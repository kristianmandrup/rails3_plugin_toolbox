module Rails
  module Plugin
    module Toolbox
      module Extender
        module Loader
          def extend_with module_name
            type = options[:in] || options        
            extend! get_module(module_name), get_type(type.to_sym)
          end
          alias_method :with, :extend_with 
        end

        def extend_rails(type, &block)
          after(type, &block)
        end
      
        def before type, &block
          raise ArgumentError "#{type} is not a valid before hook" if !valid_before_hook?
          ActiveSupport.on_load(:"before_#{type}") do |loader|
            do_loader loader, &block
          end
        end

        def after type, &block
          type = valid_after_hook? ? type : :"action_#{type}"
          raise ArgumentError "#{type} is not a valid after hook" if !valid_after_hook? type          
          ActiveSupport.on_load(type) do |loader|
            do_loader loader, &block
          end
        end
      
        protected

        def do_loader loader, &block
          loader.extend(Loader)
          if block
            block.arity < 1 ? loader.instance_eval(&block) : block.call(loader)  
          end
        end

        def valid_before_hook?
          [:initialize, :configuration, :eager_load].include?(type)          
        end

        def valid_after_hook?
          [:initialize, :i18n, :active_record, :action_view, :action_controller, :action_mailer].include?(type)          
        end

        def get_type category
           return :"action_#{type}" if [:controller, :view, :mailer].include?(type)
           return type if [:i18n, :active_record].include?(type) 
           raise ArgumentError, "The type #{type} was not recognized"
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
end
