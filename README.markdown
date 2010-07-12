# Rails3 plugin toolbox

A toolbox to facilitate creating Plugins for Rails 3 without having to necessarily know a lot about the Rails 3 internals and Plugin architecture. 

## Inspiration

This project was inspired by the Yehuda Katz article at http://www.railsdispatch.com/, titled "How Rails enables more choices".

## Install

<code>gem install rails3_plugin_toolbox</code>

## Usage

<pre>
# my_plugin/lib/load.rb
module MyPlugin
  include Rails::Plugin::Toolbox::Extender

  # do some actions after Application has been initialized using registered initializers
  after(:initialize) do
    include MyViewModule
  end

  # extend action_view with methods from some modules
  extend_rails(:view) do
    with UltraFix
    with PowerTools    
  end  
end  
</pre>

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


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
