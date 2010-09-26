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


def make_railtie name
  eval %{
    module #{name.to_s.camelize}
      class Railtie < Rails::Railtie
        extend ::Rails3::Plugin::Assist
      end
    end
  }
end  

module Rails3
  class Plugin    
    attr_reader :name 
    
    def initialize name, &block
      @name = name

      module_name = name.to_s.camelize
      make_railtie module_name
      
      railtie = "#{module_name}::Railtie".constantize

      if block
        block.arity < 1 ? railtie.instance_eval(&block) : block.call(railtie)  
      end      
    end    

    module Assist 
      def configs &block
        if block
          config.instance_eval(&block)
        end      
      end
      
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
