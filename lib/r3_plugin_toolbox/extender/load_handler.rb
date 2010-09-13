require 'r3_plugin_toolbox/extender/util'

module Rails3
  class Plugin
    class Extender
      module LoadHandler
        include ::Rails3::Plugin::Extender::Util

        def before type, &block
          type = type.to_sym
          raise ArgumentError, "#{type} is not a valid before hook" if !valid_before_hook? type
          load_handling :"before_#{type}", &block
        end

        def after type, &block
          type = type.to_sym
          raise ArgumentError, "#{type} is not a valid after hook" if !valid_after_hook? type
          load_handling :"after_#{type}", &block
        end

        def on_load type, &block    
          type = get_load_type type
          raise ArgumentError, "#{type} is not a valid load hook" if !valid_load_hook? type
          load_handling type, &block
        end
      
        def load_handling type, &block
          ActiveSupport.on_load type do
            extend Rails3::Plugin::Extender::DSL

            if block
              block.arity < 1 ? self.instance_eval(&block) : block.call(self)  
            end      
          end
        end
      end
    end
  end
end