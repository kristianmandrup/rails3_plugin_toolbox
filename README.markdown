# Rails3 plugin toolbox

This is a small toolbox that greatly facilitates creating Plugins for Rails 3 without having to know a lot about the Rails 3 internals and Plugin architecture.
The toolbox provides a convenient DSL that abstracts away the internal Rails 3 plugin wiring to an even greater extent, making the DSL dead simple to use!

I also provide a specialized RSpec 2 matcher *be_extended_with* which makes it easy to spec your plugin extension functionality, to make sure Rails is extended with
the functionality (modules) that you expect and desire ;)

## Install

<code>gem install rails3_plugin_toolbox</code>

## Usage

<pre>
# my_plugin/lib/my_plugin/rails/extensions.rb      

require 'rails/all'
require 'rails3_plugin_toolbox'

Rails3::PluginExtender.new do
  extend_from_module Ultra::View, :stuff, :in => :view 
  extend_with Ultra::Controller, :in => :controller

  before :initialize do
    "Rails not yet initialized!"
  end      

  extend_rails :i18n do
    with MyAddition
    extend_from_module Ultra::Power, :util, :logging, :monitor

    before :initialize do
      MyOtherAddition.say 'before localized!'
    end      

    before :configuration do
      MyOtherAddition.configured = 'was configured!'      
    end

    before :eager_load do
      puts "before eager load!"
    end

    after :initialize do
      MyAddition.say 'localized!'
    end      
  end
end
</pre>

More API examples

<pre>                        
Rails3::PluginExtender.new do  
  extend_rails :view do # or use :action_view
    with MyViewAddition
  end

  extend_rails :controller do # or use :action_mailer
    with MyViewAddition
  end

  extend_rails :mailer do # or use :action_mailer
    with MyMailAddition, 'MyOtherMailAddition'
  end

  extend_rails :AR do # active record
    with MyActiveRecordAddition
  end

  extend_rails :active_record do
    with MyExtraScopeHelpers
  end

  extend_rails(:controller) do
    extend_from_module Ultra::Power, :util, :logging, :monitor
    extend_from_module Ultra::Power::More, :extra, :stuff
  end  
  
  after(:initialize) do
    puts "Rails initialized!"
  end    
end
</pre>

## RSpec 2 matchers

The library comes with a special Matcher to facilitate making Rails 3 extension specs

* be_extended_with module_name, *submodules

_Usage example:_

<pre>   
                   
require 'rspec'
require 'rails3_plugin_toolbox'
require 'rails/all'  

describe "My Plugin rails extensions" do
  it "should extend Action View with View Helpers" do
    Rails3::PluginExtender.new do
      extend_rails :view do          
        extend_from_module Helper::View, :panel, :window
        extend_with Helper::View::Button, Helper::View::Form
      end
    end

    after_init :view do
      :view.should be_extended_with Helper::View, :panel, :window, :button, :form
      :view.should_not be_extended_with Helper::View, :unknown
    end

    after_init :controller do
      :controller.should be_extended_with Helper::Controller, :stuff
      :controller.should_not be_extended_with My::Paginator
    end

    # first arg is the App name, the remaining symbols are 
    # the identifiers for which railties to initialize
    init_app_railties :minimal, :view, :controller
  end  
end

# alternative RSpec configuration using macros

describe "My other Plugin rails extensions" do
  before :each do
    Rails3::PluginExtender.new do
      extend_rails :view do          
        extend_from_module Helper::View, :grid, :tree      
      end        
    end
  end

  after_init :view do
    :view.should be_extended_with Helper::View, :panel, :window, :button, :form
  end

  it "should extend Action View" do      
    init_app_railties :minimal, :view
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
