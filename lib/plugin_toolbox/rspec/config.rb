require 'rspec'

RSpec.configure do |config|
  config.include Rails3::PluginExtender::Matchers
  config.extend Rails3::PluginExtender::Macro
end

module RSpec::Core
  class ExampleGroup
    include Rails3::PluginExtender::Macro
  end
end