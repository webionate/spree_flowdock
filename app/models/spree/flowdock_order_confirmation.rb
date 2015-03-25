require 'flowdock'

module Spree
  class FlowdockOrderConfirmation

    attr_reader :flow, :order

    def initialize(order)
      raise ArgumentError.new('Order missing.') if order.blank?

      @flow = flow
      @order = order
    end

    def push
      return false if @flow.nil?
      # send message to Team Inbox
      @flow.push_to_team_inbox(
        subject: I18n.t('flowdock.order.confirmation.subject', store_name: current_store.name),
        content: I18n.t('flowdock.order.confirmation.content_html', order_number: @order.number, order_total: @order.display_total),
        tags: tags,
        link: link
      )
    end

    private

    def flow
      if api_token.blank?
        Rails.logger.error "Flowdock order confirmation API token is not configured."
        return nil
      end
      # create a new Flow object with target flow's api token and sender information for Team Inbox posting
      Flowdock::Flow.new(api_token: api_token, source: source, from: { name: name, address: address })
    end

    def api_token
      @_api_token ||= flowdock_configuration.api_token_order_confirmation
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

    def tags
      [Rails.env, 'order', 'incoming', @order.number]
    end

    def link
      "#{current_store.url}/de/admin/orders/#{@order.number}/edit"
    end

  end
end
