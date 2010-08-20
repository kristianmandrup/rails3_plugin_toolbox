module Rails::PluginToolbox
  module HookValidator
    def valid_before_hook?
      [:initialize, :configuration, :eager_load].include?(type)          
    end

    def valid_after_hook?
      [:initialize, :i18n, :active_record, :action_view, :action_controller, :action_mailer].include?(type)          
    end
  end
end