# See: http://edgeapi.rubyonrails.org/classes/Rails/Engine.html

# Any Rails::Engine is also a Rails::Railtie, so the same methods (like rake_tasks and generators) and configuration available in the latter can also be used in the former. 

require 'r3_plugin_toolbox/railtie'

module Rails3
  class Engine < ::Rails3::Plugin   
    attr_reader :name    
    
    def initialize name, &block
      @name = name
      
      class_eval %{
        module #{name.to_s.camelize}
          class Engine < ::Rails::Engine
            engine_name :#{name.to_s.underscore}
            
            include ::Rails3::Engine::Assist
          end
        end        
      }
    end  

    module Assist   
      include ::Rails3::Plugin::Assist            
      
      [:autoload, :eagerload].each do |name|
        class_eval %{
          def add_#{name}_paths path
            config.#{name}_paths << path
          end          
        }
      end
    
      [:controllers, :helpers, :models, :views].each do |name|
        class_eval %{
          def add_#{name}_dir path
            paths.app.#{name} << path
          end
        }
      end    
    
      [:initializers, :locales, :routes].each do |name|
        class_eval %{
          def add_#{name}_dir path
            paths.config.#{name} << path
          end
        }
      end

      def add_tasks_dir path
        paths.lib.tasks << path
      end
    end
  end
end        

# Example

# class MyEngine < Rails::Engine
#   # Add a load path for this specific Engine
#   config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)
# 
#   initializer "my_engine.add_middleware" do |app|
#     app.middleware.use MyEngine::Middleware
#   end
# end

