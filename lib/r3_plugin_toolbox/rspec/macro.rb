module Rails3
  class Plugin
    class Extender
      module Macro
        class << self
          include Rails3::Plugin::Extender::Util
        end

        MACRO = Rails3::Plugin::Extender::Macro

        def with_engine name, &block
          Rails3::Engine.new name do |e|
            yield e
          end
        end

        def with_configuration &block
          if block
            block.arity < 1 ? Rails.configuration.instance_eval(&block) : block.call(Rails.configuration)  
          end      
        end

        def with_extension &block
          Rails3::Plugin::Extender.new do |e|
            e.instance_eval(&block)
          end
        end
            
        def after_init component, &block
          type = MACRO.get_load_type component
          Rails3::Plugin::Extender.new do
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
end
