module Rails3
  class PluginExtender
    module Macro
      ACTIVE_MODULES = {:AR => :active_record, :view => :action_view, :controller => :action_controller, :mailer => :action_mailer}    
            
      def after_init component, &block
        type = get_load_type component
        Rails3::PluginExtender.new do
          extend_rails type do          
            after :initialize do
              yield self
            end
          end
        end        
      end # def
         
      protected

      def get_load_type type
         return ACTIVE_MODULES[type] if ACTIVE_MODULES[type]
         return type if ACTIVE_MODULES.values.include? type                
         return type if type == :i18n
         logger.warn "WARNING: The Rails 3 load handler for the component #{type} is not part of the default load process."
      end
      
    end
  end
end

