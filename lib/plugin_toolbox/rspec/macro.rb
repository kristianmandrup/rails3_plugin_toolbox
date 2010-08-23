module Rails3
  class PluginExtender
    module Macro
      class << self
        include Rails3::PluginExtender::Util
      end

      MACRO = Rails3::PluginExtender::Macro
            
      def after_init component, &block
        type = MACRO.get_load_type component
        Rails3::PluginExtender.new do
          extend_rails type do          
            after :initialize do
              yield self
            end
          end
        end        
      end # def

      def init_app_railties app_name, *railties
        app = "#{app_name.to_s.camelize}::Application".constantize 
        app.initialize!                        
        railties.each do |railtie|
          MACRO.get_base_class(railtie).constantize
        end
      end
               
    end
  end
end

