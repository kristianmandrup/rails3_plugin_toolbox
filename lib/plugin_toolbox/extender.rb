require 'plugin_toolbox/util'

module Rails3
  class PluginExtender
    include LoadHandler
     
    def initialize &block
      if block
        block.arity < 1 ? self.instance_eval(&block) : block.call(self)  
      end      
    end

    # load after: [:initialize, :configuration, :eager_load]
    def extend_rails(type, &block)
      on_load(type, &block)
    end

    
    # convenience method to extend with multiple modules all within the same base module
    def extend_from_module base_name, *module_names, options
      raise ArgumentError, "You must specify an options Hash as the last argument for #extend_from_module" if !options.kind_of? Hash      
      module_names.each do |name|
        extend_with "#{base_name.camelize}::#{name.to_s.camelize}".constantize, options
      end
    end

    def extend_with *module_names, options
      raise ArgumentError, "You must specify an options Hash as the last argument for #extend_with" if !options.kind_of? Hash      
      type = options[:in]
      raise ArgumentError, "You must specify an :in option to indicate which Rails 3 component base class to extend with #{module_names}" if !type
      module_names.each do |name|      
        extend! name, type
      end
    end
    
    module DSL         
      include Rails3::PluginExtender::LoadHandler      
      
      def extend_from_module base_name, *module_names
        module_names.each do |name|
          include "#{base_name.camelize}::#{name.to_s.camelize}".constantize
        end
      end

      def extend_with *module_names
        module_names.each do |name|         
          include name
        end
      end
      alias_method :with, :extend_with
    end

    protected

    def extend! module_name, type
      do_extend! get_module(module_name), get_load_type(type.to_sym)
    end

    def do_extend! module_name, type
      ActiveSupport.on_load(type) do
        include module_name
      end        
    end
  end
end