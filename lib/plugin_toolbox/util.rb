require_all File.dirname(__FILE__) + '/validator'

module Rails::PluginToolbox
  module Util    
    include Rails::PluginToolbox::TypeValidator
    
    def get_type category
       return :"action_#{type}" if action_type?(type)
       return type if valid_type?(type)
       raise ArgumentError, "The type #{type} was not recognized"
    end

    def get_module module_name
      case module_name
      when Constant        
        module_name
      when String
        module_name.to_s.constantize
      else          
        raise ArgumentError, "#{module_name} could not be converted into a loaded module"        
      end
    end
  end
end