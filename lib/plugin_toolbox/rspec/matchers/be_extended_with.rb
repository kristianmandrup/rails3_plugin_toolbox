module Rails3
  class PluginExtender
    module Matchers
      class BeExtendedWith
        include Rails3::PluginExtender::Util          
      
        attr_reader :methods, :module_const, :rails_const, :submodules
      
        def initialize(module_const, submodules=nil)
          @module_const = module_const     
          raise ArgumentError, "List of submodules must be given as a collection of Symbols or Strings" if submodules && !submodules.respond_to?(:flatten)
          @submodules = submodules.flatten if submodules
        end

        def matches? type
          begin
            @rails_const = get_base_class(type)                  
            return match_submodules? if submodules
            methods_included? module_const.instance_methods 
          rescue
            false
          end
        end

        def base_class_methods 
          (rails_const == I18n) ? rails_const.methods : rails_const.instance_methods
        end

        def match_submodules?
          submodules.each do |name|
            return false if !methods_included? get_methods(name)            
          end
          true
        end

        def methods_included? methods
          (base_class_methods & methods) == methods
        end

        def get_methods name
          get_constant(module_const, name).instance_methods
        end
  
        def failure_message   
          "Expected the rails class #{rails_const} to be extended with all the methods in #{module_const}"
        end 
  
        def negative_failure_message  
          "Din not expect the rails class #{rails_const} to be extended with all the methods in #{module_const}"
        end                   
      end
    
      def be_extended_with(module_const, *submodules)
        BeExtendedWith.new module_const, submodules
      end
    end
  end
end