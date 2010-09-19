The following are some general tips for adding custom rake tasks and generators to your Rails 3 plugin.

## Custom rake tasks

<pre>
# my_plugin/lib/railtie.rb
module MyPlugin
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "my_plugin/railties/tasks.rake"    
    end
  end    
end
</pre>

<pre>
# my_plugin/lib/railties/tasks.rake
desc "Talk about being in my_gem"
task :my_gem do
  puts "You're in my_gem"
end     
</pre>