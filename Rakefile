begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rails3_plugin_toolbox"
    gem.summary = %Q{Toolbox to facilitate Rails 3 plugin development}
    gem.description = %Q{Provides a more intuitive DSL for Rails 3 plugin configuration and a specialized RSpec 2 matcher. Makes it much easier to develop Rails 3 plugins!}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/rails3_plugin_toolbox"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.19"

    # gem.add_dependency 'active_support', ">= 3.0.0.rc"
    gem.add_dependency "rails", "~> 3.0"
    gem.add_dependency "require_all", ">= 1.1.0"

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

