require 'flowdock'

module Spree
  class FlowdockOrderConfirmation < FlowdockInboxMessage

    attr_reader :order

    def initialize(order)
      raise ArgumentError.new('Order missing.') if order.blank?

      @flow = flow
      @order = order
    end

    private

    def subject
      I18n.t('flowdock.order.confirmation.subject', store_name: current_store.name)
    end

    def content
      I18n.t('flowdock.order.confirmation.content_html', order_number: @order.number, order_total: @order.display_total)
    end

    def tags
      [Rails.env, 'order', 'incoming', @order.number]
    end

    def link
      "#{current_store.url}/de/admin/orders/#{@order.number}/edit"
    end

    def configured_token
      flowdock_configuration.api_token_order_confirmation
    end
  end
end
