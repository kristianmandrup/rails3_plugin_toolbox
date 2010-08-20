require 'plugin_toolbox/util'

module Rails::PluginToolbox
  class Extender
    include Rails::PluginToolbox::Util
    
    attr_reader :loader
    
    def initialize
      @loader = Loader.new
    end
    
    def extend_rails(type, &block)
      loader.load_after(type, &block)
    end
    
    def extend! module_name, type
      do_extend! get_module(module_name), get_type(type.to_sym)
    end
    
    def extend_with module_name
      type = options[:in] || options        
      extend! module_name, type
    end
    alias_method :with, :extend_with

    # convenience method to extend with multiple modules all within the same base module
    def extend_from_module base_name, *module_names
      module_names.each do |name|
        extend_with "#{base_name.camelize}::#{name.to_s.camelize}".constantize
      end
      type = options[:in] || options        
      extend! module_name, type
    end       
    
    protected
    
    def do_extend! module_name, type
      ActiveSupport.on_load(type) do
        include module_name
      end        
    end    
    
  end
end