require 'rspec/core'
require 'r3_plugin_toolbox/rspec/macro'
require_all File.dirname(__FILE__) + '/matchers'

RSpec.configure do |config|
  config.include Rails3::Plugin::Extender::Matchers
  config.extend Rails3::Plugin::Extender::Macro
end

module RSpec::Core
  class ExampleGroup
    include Rails3::Plugin::Extender::Macro
  end
end