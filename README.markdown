# Rails3 plugin toolbox

A toolbox to facilitate creating Plugins for Rails 3 without having to necessarily know a lot about the Rails 3 internals and Plugin architecture.   

## RSpec test suite

I have now discovered how to test he validity of Rails extensions in RSpec without having to have a full Rails 3 host app.
RSpec 2 test suite will soon be added :)

http://gist.github.com/542441

## Inspiration

This project was inspired by the Yehuda Katz article at http://www.railsdispatch.com/, titled "How Rails enables more choices".

## Install

<code>gem install rails3_plugin_toolbox</code>

## Usage

<pre>
# my_plugin/lib/load.rb
module MyPlugin
  Rails3::PluginExtender.new do
  
    extend_from_module Ultra::View, :stuff, :in => :view 
    extend_with Ultra::Controller, :in => :controller
  
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

    extend_rails :view do
      with MyViewAddition
    end

    extend_rails :controller do
      with MyViewAddition
    end

    extend_rails :mailer do
      with MyMailAddition, 'MyOtherMailAddition'
    end

    extend_rails :AR do
      with MyActiveRecordAddition
    end

    extend_rails(:controller) do
      extend_from_module Ultra::Power, :util, :logging, :monitor
      extend_from_module Ultra::Power::More, :extra, :stuff
    end  
    
    after(:initialize) do
      include MyCoreModule
    end    
  end
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
