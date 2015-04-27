require 'flowdock'

module Spree
  class FlowdockInboxMessage

    attr_reader :flow, :message, :type

    def initialize(message, type = :info)
      raise ArgumentError.new('Message missing.') if message.blank?

      @flow = flow
      @message = message
      @type = type
    end

    def push
      return false if @flow.nil?
      # send message to Team Inbox
      @flow.push_to_team_inbox(
        subject: subject,
        content: content,
        tags: tags,
        link: link
      )
    end

    private

    def flow
      if api_token.blank?
        Rails.logger.error "Flowdock API token is not configured."
        return nil
      end
      # create a new Flow object with target flow's api token and sender information for Team Inbox posting
      Flowdock::Flow.new(api_token: api_token, source: source, from: { name: name, address: address })
    end

    def api_token
      @_api_token ||= configured_token
    end

    def flowdock_configuration
      @_configuration ||= Spree::FlowdockConfiguration.new
    end

    def current_store
      @_store ||= Spree::Store.current(Rails.env)
    end

    def source
      current_store.name ||= Rails.application.class.parent_name
    end

    def name
      source
    end

    def address
      current_store.mail_from_address ||= 'spree@example.com'
    end

    # Override the following methods in child classes

    def subject
      I18n.t('flowdock.inbox_message.subject', message_type: I18n.t("flowdock.inbox_message.type.#{@type}"), store_name: current_store.name)
    end

    def content
      @message
    end

    def tags
      [Rails.env, @type.to_s, 'message']
    end

    def link
      "#{current_store.url}"
    end

    def configured_token
      flowdock_configuration.api_token_inbox_message
    end
  end
end
