Any Rails::Engine is also a Rails::Railtie, so the same methods (like rake_tasks and generators) and configuration available in the latter can also be used in the former. 

<pre>
  class MyEngine < Rails::Engine
    # Add a load path for this specific Engine
    config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)

    initializer "my_engine.add_middleware" do |app|
      app.middleware.use MyEngine::Middleware
    end
  end  
</pre>
            
h2.Paths

Since Rails 3.0, both your Application and Engines do not have hardcoded paths. This means that you are not required to place your controllers at “app/controllers“, but in any place which you find convenient.

For example, let’s suppose you want to lay your controllers at lib/controllers, all you need to do is:

<pre>
  class MyEngine < Rails::Engine
    paths.app.controllers = "lib/controllers"
  end
  
</pre>

You can also have your controllers being loaded from both “app/controllers“ and “lib/controllers“:

<pre>
  class MyEngine < Rails::Engine
    paths.app.controllers << "lib/controllers"
  end  
</pre>  

The available paths in an Engine are:

<pre>
  class MyEngine < Rails::Engine
    paths.app                 = "app"
    paths.app.controllers     = "app/controllers"
    paths.app.helpers         = "app/helpers"
    paths.app.models          = "app/models"
    paths.app.views           = "app/views"
    paths.lib                 = "lib"
    paths.lib.tasks           = "lib/tasks"
    paths.config              = "config"
    paths.config.initializers = "config/initializers"
    paths.config.locales      = "config/locales"
    paths.config.routes       = "config/routes.rb"
  end
  
</pre>
