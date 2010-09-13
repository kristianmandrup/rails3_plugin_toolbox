def rails3_extensions &block
  Rails3::Plugin::Extender.new &block
end

def rails3_plugin name, &block
  Rails3::Plugin.new name, &block
end

def rails3_engine name, &block
  Rails3::Engine.new name, &block
end
