module Rails3
  class Plugin
    class Extender
      module Matchers
        class BeExtendedWith
          include Rails3::Plugin::Extender::Util
      
          attr_reader :methods, :module_const, :rails_const, :submodules, :cause, :rails_const_name, :bad_const
      
          def initialize(module_const, submodules=nil)
            @module_const = module_const     
            raise ArgumentError, "List of submodules must be given as a collection of Symbols or Strings" if submodules && !submodules.respond_to?(:flatten)
            @submodules = submodules.flatten if submodules
          end

          def matches? type
            begin  
              @rails_const_name = get_base_class(type)
              @bad_const = module_const
              @rails_const = rails_const_name.constantize            
            
              return match_submodules? if submodules            

              methods_included? module_const.instance_methods 
            rescue
              @cause = ", but the extension module #{@rails_const} wasn't found"
              false
            end
          end

          def base_class_methods 
            (rails_const == I18n) ? rails_const.methods : rails_const.instance_methods
          end

          def match_submodules? 
            submodules.each do |name|
              @bad_const = make_constant(module_const, name)
              if !methods_included? get_methods(name)
                return false 
              end
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
            "Expected the rails class #{rails_const_name} to be extended with the methods in #{bad_const}#{cause}"
          end 
  
          def negative_failure_message  
            "Did not expect the rails class #{rails_const_name} to be extended with the methods in #{bad_const}"
          end                   
        end
    
        def be_extended_with(module_const, *submodules)
          BeExtendedWith.new module_const, submodules
        end
      end
    end
  end
end