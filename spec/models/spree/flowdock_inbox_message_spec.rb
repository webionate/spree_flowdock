require 'spec_helper'

describe Spree::FlowdockInboxMessage do

  describe '#initialize' do
    it 'raises an argument error when no order is passed along' do
      create_store
      expect{ Spree::FlowdockInboxMessage.new(nil) }.to raise_error(ArgumentError, 'Message missing.')
    end

    it 'raises no error when order is being passed along' do
      create_store
      expect{ Spree::FlowdockInboxMessage.new('An error occured') }.not_to raise_error
    end
  end

  describe '#push' do
    it 'returns false if api token is not set' do
      create_api_token(nil)
      expect(Spree::FlowdockInboxMessage.new('An error occured').push).to eq false
    end

    it 'does not push a message to flowdock if api token is not set' do
      create_api_token(nil)
      stub = stub_request(:any, 'api.flowdock.com')
      Spree::FlowdockInboxMessage.new('An error occured').push
      expect(stub).not_to have_been_requested
    end

    it 'does push a message to flowdock' do
      create_api_token('test')
      stub = stub_request(:post, "https://api.flowdock.com/v1/messages/team_inbox/test")
        .with(
          :body => "source=Spree%20Test%20Store&format=html&from_address=spree%40example.org&subject=New%20error%20at%20Spree%20Test%20Store!&content=An%20error%20occured&from_name=Spree%20Test%20Store&tags=test%2Cerror%2Cmessage&link=www.example.org",
          :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}
        )
        .to_return(
          :status => 200,
          :body => "",
          :headers => {}
        )
      Spree::FlowdockInboxMessage.new('An error occured', :error).push
      expect(stub).to have_been_requested
    end
  end

  def create_api_token(token)
    create_store
    Spree::FlowdockConfiguration.new.configure do |config|
      config.api_token_inbox_message = token
    end
  end

  def create_store
    store = create(:store,
        name: 'Spree Test Store',
        url: 'www.example.org',
        mail_from_address: 'spree@example.org')
  end
end
