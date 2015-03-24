require 'spec_helper'

describe Spree::FlowdockOrderConfirmation do

  describe '#initialize' do
    it 'raises an argument error when no order is passed along' do
      config_flow_api_token
      create_store
      expect{ Spree::FlowdockOrderConfirmation.new(nil) }.to raise_error(ArgumentError, 'Order missing.')
    end

    it 'raises an argument error when no flowdock api token is configured' do
      order = create(:order)
      config_flow_api_token(nil)
      create_store
      expect{ Spree::FlowdockOrderConfirmation.new(order) }.to raise_error(ArgumentError, 'Flowdock API token not configured.')
    end

    it 'raises an argument error when no store name is configured' do
      order = create(:order)
      config_flow_api_token
      create_store
      allow_any_instance_of(Spree::Store).to receive(:name).and_return(nil)
      expect{ Spree::FlowdockOrderConfirmation.new(order) }.to raise_error(ArgumentError, 'Current store name not configured.')
    end

    it 'raises an argument error when no store mail from address is configured' do
      order = create(:order)
      config_flow_api_token
      create_store
      allow_any_instance_of(Spree::Store).to receive(:mail_from_address).and_return(nil)
      expect{ Spree::FlowdockOrderConfirmation.new(order) }.to raise_error(ArgumentError, 'Current store mail_from_address not configured.')
    end

    it 'raises no error when all needed values are configured and passed along' do
      order = create(:order)
      config_flow_api_token
      create_store
      expect{ Spree::FlowdockOrderConfirmation.new(order) }.not_to raise_error
    end
  end

  describe '#push' do
    it "pushes a order confirmation to the flow's team inbox" do
      pending 'find a way to mock flowdock'

      order = create(:order)
      config_flow_api_token
      store = create_store

      flow_double = instance_double(Flowdock::Flow.name)
      allow(flow_double).to receive(:push_to_team_inbox)

      allow(Flowdock::Flow).to receive(:new).with(
        api_token: "0a3e060cff7212f1ef15d012cc17cd5b",
        source: "Test Store",
        from: { name: "Test Store", address: "test@example.org" }
      ).and_return(flow_double)

      expect(flow_double).to receive(:push_to_team_inbox).with(
        subject: "Daily Shipment Fees Billing",
        content: "Incoming order #{order.number} for #{store.name}",
        tags: ["test", "order", "incoming", order.number]
      )

      expect(Spree::FlowdockOrderConfirmation.new(order).push).to be_true
    end
  end

  def config_flow_api_token(token = 'test')
    Spree::FlowdockConfiguration.new.configure do |config|
      config.flow_api_token = token
    end
  end

  def create_store
    create(:store, name: 'Test Store', url: 'test.example.org', mail_from_address: 'test@example.org')
  end
end
