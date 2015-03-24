require 'flowdock'

module Spree
  class FlowdockOrderConfirmation

    attr_reader :flow, :order

    def initialize(order)
      raise ArgumentError.new('Order missing.') if order.blank?
      raise ArgumentError.new('Flowdock API token not configured.') if flow_api_token.blank?
      raise ArgumentError.new('Current store name not configured.') if current_store.name.blank?
      raise ArgumentError.new('Current store mail_from_address not configured.') if current_store.mail_from_address.blank?

      @flow = flow
      @order = order
    end

    def push
      # send message to Team Inbox
      @flow.push_to_team_inbox(
        subject: I18n.t('flowdock.order.confirmation.subject', store_name: current_store.name ),
        content: I18n.t('flowdock.order.confirmation.content_html', order_number: @order.number, order_total: @order.total ),
        tags: tags,
        link: link
      )
    end

    private

    def flow
      # create a new Flow object with target flow's api token and sender information for Team Inbox posting
      Flowdock::Flow.new(api_token: flow_api_token, source: current_store.name, from: { name: current_store.name , address: current_store.mail_from_address})
    end

    def flow_api_token
      @_flow_api_token ||= flowdock_configuration.flow_api_token
    end

    def flowdock_configuration
      @_configuration ||= Spree::FlowdockConfiguration.new
    end

    def current_store
      @_store ||= Spree::Store.current(Rails.env)
    end

    def tags
      tags = [Rails.env, 'order', 'incoming', @order.number]
    end

    def link
      "#{current_store.url}/de/admin/orders/#{@order.number}/edit"
    end

  end
end
