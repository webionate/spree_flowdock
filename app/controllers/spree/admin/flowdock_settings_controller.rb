module Spree
  module Admin
    class FlowdockSettingsController < Spree::Admin::BaseController

      def edit
        @config = Spree::FlowdockConfiguration.new
      end

      def update
        save_settings(params[:preferences])
        redirect_to edit_admin_flowdock_settings_path
      end

      private

      def save_settings(values)
        config = Spree::FlowdockConfiguration.new
        values.each do |name, value|
          next unless config.has_preference? name
          config[name] = value
        end
      end

    end
  end
end
