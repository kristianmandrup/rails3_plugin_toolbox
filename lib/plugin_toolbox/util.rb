module Rails3
  class PluginExtender
    module Util    
      INIT = :initialize    
      ACTIVE_MODULES = {:AR => :active_record, :view => :action_view, :controller => :action_controller, :mailer => :action_mailer}    

      def get_base_class type
        begin
          type = get_load_type(type).to_s
          const = act_type?(type) ? rails_const_base(type) : "#{type.to_s.camelize}"          
          const.constantize        
        rescue                            
          raise ArgumentError, "Can't find rails constant: #{const}"
        end
      end

      def act_type? type
        type =~/action/ || type =~/active/        
      end

      def get_constant base_name, name   
        make_constant(base_name, name).constantize
      end

      def rails_const_base type
        "#{type.to_s.camelize}::Base"
      end

      def make_constant base_name, name
        "#{base_name.to_s.camelize}::#{name.to_s.camelize}"
      end

      def get_load_type type
         return ACTIVE_MODULES[type] if ACTIVE_MODULES[type]
         return type if ACTIVE_MODULES.values.include? type                
         return type if type == :i18n
         logger.warn "WARNING: The Rails 3 load handler for the component #{type} is not part of the default load process."
      end

      def get_module module_name
        case module_name
        when Constant        
          module_name
        when String
          module_name.to_s.constantize
        else          
          raise ArgumentError, "#{module_name} could not be converted into a module constant"        
        end
      end

      protected
    
      def valid_before_hook? type
        [INIT, :configuration, :eager_load].include?(type)          
      end

      def valid_after_hook? type
        INIT == type
      end

      def valid_load_hook? type
        @valid_load_hooks ||= [ACTIVE_MODULES.keys, ACTIVE_MODULES.values, :i18n].flatten
        @valid_load_hooks.include?(type)          
      end    
    end
  end
end