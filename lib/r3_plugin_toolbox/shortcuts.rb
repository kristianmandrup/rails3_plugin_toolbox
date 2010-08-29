def rails3_extensions &block
  Rails3::Plugin::Extender.new &block
end

def rails3_plugin &block
  Rails3::Plugin.new &block
end

def rails3_engine &block
  Rails3::Engine.new &block
end
