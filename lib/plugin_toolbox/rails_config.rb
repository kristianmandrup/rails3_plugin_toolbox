# 

# See http://www.igvita.com/2010/08/04/rails-3-internals-railtie-creating-plugins/

require 'active_support/railtie'

module Minimal
  class Application < Rails::Application
    config.active_support.deprecation
  end
end

module MyAddition
  def zzz
    puts "Hello from MyAddition"
  end
end

ActiveSupport.on_load(:action_view) do
  puts "extending action_view: #{self}"  
  include MyAddition
end

ActiveSupport.on_load(:action_controller) do
  puts "extending action_controller #{self}"
  include MyAddition
end

# Initialize the rails application
Minimal::Application.initialize!

class MyController < ActionController::Base
end

class MyView < ActionView::Base
end

puts ActionController::Base.instance_methods.grep /zzz/
puts ActionView::Base.instance_methods.grep /zzz/

MyController.new.zzz
MyView.new.zzz