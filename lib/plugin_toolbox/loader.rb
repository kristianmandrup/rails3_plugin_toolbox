require_all File.dirname(__FILE__) + '/validator'

module Rails::PluginToolbox
  class Loader
    include Rails::PluginToolbox::HookValidator
        
    def load_before type, &block
      raise ArgumentError "#{type} is not a valid before hook" if !valid_before_hook?
      ActiveSupport.on_load(:"before_#{type}") do |loader|
        do_loader loader, &block
      end
    end

    def load_after type, &block
      type = valid_after_hook? ? type : :"action_#{type}"
      raise ArgumentError "#{type} is not a valid after hook" if !valid_after_hook? type          
      ActiveSupport.on_load(type) do |loader|
        do_loader loader, &block
      end
    end

    protected

    def do_loader loader, &block
      loader.extend(Loader)
      if block
        block.arity < 1 ? loader.instance_eval(&block) : block.call(loader)  
      end
    end           
  end
end