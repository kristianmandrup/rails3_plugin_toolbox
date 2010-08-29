# See: http://edgeapi.rubyonrails.org/classes/Rails/Railtie.html

# Add a to_prepare block which is executed once in production
# and before each request in development
# config.to_prepare do
#   MyRailtie.setup!
# end

# rake_tasks do
#   load "path/to/my_railtie.tasks"
# end
      
# generators do
#   require "path/to/my_railtie_generator"
# end


module Rails3
  class Plugin    
    attr_reader :name 
    
    def initialize name, &block
      @name = name

      class_eval %{
        module #{name.to_s.camelize}
          class Railtie < Rails::Railtie
              include ::Rails3::Plugin::Assist
              
              railtie_name :#{name.to_s.underscore}
                            
              #{yield}
          end
        end
      }
    end    

    module Assist
      def set_test_framework name
        config.generators.test_framework name
      end

      def use_middleware middleware
        app.middleware.use middleware
      end

      def set_orm orm_name
        config.generators.orm(orm_name)
      end      
    
      def subscribe_notifications *args, &block
        ActiveSupport::Notifications.subscribe do |*args|
          yield *args
        end
      end
    end
  end
end

# Example

# module NewPlugin
#   # namespace our plugin and inherit from Rails::Railtie
#   # to get our plugin into the initialization process
#   class Railtie < Rails::Railtie
#  
#     # configure our plugin on boot. other extension points such
#     # as configuration, rake tasks, etc, are also available
#     initializer "newplugin.initialize" do |app|
#  
#       # subscribe to all rails notifications: controllers, AR, etc.
#       ActiveSupport::Notifications.subscribe do |*args|
#         event = ActiveSupport::Notifications::Event.new(*args)
#         puts "Got notification: #{event.inspect}"
#       end 
#     end
#   end
# end
