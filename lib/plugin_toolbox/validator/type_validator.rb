module Rails::PluginToolbox
  module TypeValidator
    def valid_type?
      [:i18n, :active_record].include?(type)       
    end

    def action_type? type
      [:controller, :view, :mailer].include?(type)
    end
  end
end