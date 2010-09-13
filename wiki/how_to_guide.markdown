http://www.igvita.com/2010/08/04/rails-3-internals-railtie-creating-plugins/

The documentation for Railtie  is a great place to get started, but the interesting observation is that each of the major Rails components (Action Mailer/Controller/View/Record) is itself a Railtie, and Rails as you know it is simply pieced together  by requiring all of the independent components. Even better, if your plugin or gem needs to hook into the Rails initialization process, all you need to do is inherit from Railtie and you are ready to go!

So how does Railtie know to call your classes and initializers? Railtie defines a self.inherited method, which is called anytime a subclass of Railtie is created, and stashes a reference to this class in a @subclasses variable. From there, the framework can simply call Railtie.subclasses and perform all the initialization as usual - a clever use of the Ruby object model.

module NewPlugin
  # namespace our plugin and inherit from Rails::Railtie
  # to get our plugin into the initialization process
  class Railtie < Rails::Railtie
 
    # configure our plugin on boot. other extension points such
    # as configuration, rake tasks, etc, are also available
    initializer "newplugin.initialize" do |app|
 
      # subscribe to all rails notifications: controllers, AR, etc.
      ActiveSupport::Notifications.subscribe do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        puts "Got notification: #{event.inspect}"
      end
 
    end
  end
end
                             
---

Railtie is the core of the Rails Framework and provides several hooks to extend Rails and/or modify the initialization process.

Every major component of Rails (Action Mailer, Action Controller, Action View, Active Record and Active Resource) are all Railties, so each of them is responsible to set their own initialization. This makes, for example, Rails absent of any Active Record hook, allowing any other ORM framework to hook in.

Developing a Rails extension does not require any implementation of Railtie, but if you need to interact with the Rails framework during or after boot, then Railtie is what you need to do that interaction.

For example, the following would need you to implement Railtie in your plugin:

* creating initializers
* configuring a Rails framework or the Application, like setting a generator
* adding Rails config.* keys to the environment
* setting up a subscriber to the Rails +ActiveSupport::Notifications+
* adding rake tasks into rails

h2. Creating your Railtie

Implementing Railtie in your Rails extension is done by creating a class Railtie that has your extension name and making sure that this gets loaded during boot time of the Rails stack.

You can do this however you wish, but here is an example if you want to provide it for a gem that can be used with or without Rails:

* Create a file (say, lib/my_gem/railtie.rb) which contains class Railtie inheriting from Rails::Railtie and is namespaced to your gem:
                                                                                                                                       
<pre>
  # lib/my_gem/railtie.rb
  module MyGem
    class Railtie < Rails::Railtie
    end
  end  
</pre>

* Require your own gem as well as rails in this file:

<pre>
  # lib/my_gem/railtie.rb
  require 'my_gem'
  require 'rails'

  module MyGem
    class Railtie < Rails::Railtie
    end
  end  
</pre>

h2. Initializers

To add an initialization step from your Railtie to Rails boot process, you just need to create an initializer block:

<pre>
  class MyRailtie < Rails::Railtie
    initializer "my_railtie.configure_rails_initialization" do
      # some initialization behavior
    end
  end  
</pre>

If specified, the block can also receive the application object, in case you need to access some application specific configuration, like middleware:

<pre>
  class MyRailtie < Rails::Railtie
    initializer "my_railtie.configure_rails_initialization" do |app|
      app.middleware.use MyRailtie::Middleware
    end
  end  
</pre>

Finally, you can also pass :before and :after as option to initializer, in case you want to couple it with a specific step in the initialization process.
Configuration

Inside the Railtie class, you can access a config object which contains configuration shared by all railties and the application:

<pre>
  class MyRailtie < Rails::Railtie
    # Customize the ORM
    config.generators.orm :my_railtie_orm

    # Add a to_prepare block which is executed once in production
    # and before each request in development
    config.to_prepare do
      MyRailtie.setup!
    end
  end  
</pre>

Loading rake tasks and generators

If your railtie has rake tasks, you can tell Rails to load them through the method rake tasks:

<pre>
  class MyRailtie < Railtie
    rake_tasks do
      load "path/to/my_railtie.tasks"
    end
  end  
</pre>

By default, Rails load generators from your load path. However, if you want to place your generators at a different location, you can specify in your Railtie a block which will load them during normal generators lookup:

<pre>
  class MyRailtie < Railtie
    generators do
      require "path/to/my_railtie_generator"
    end
  end  
</pre>

Application, Plugin and Engine

A Rails::Engine is nothing more than a Railtie with some initializers already set. And since Rails::Application and Rails::Plugin are engines, the same configuration described here can be used in all three.

Be sure to look at the documentation of those specific classes for more information.

Methods:

    * abstract_railtie?
    * console
    * eager_load!
    * generators
    * inherited
    * load_console
    * load_generators
    * load_tasks
    * log_subscriber
    * railtie_name
    * rake_tasks
    * subclasses

