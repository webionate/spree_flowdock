require 'spec_helper'

describe "Checkout" do

  stub_authorization!

  let!(:country) { create(:country, states_required: true) }
  let!(:state) { create(:state, country: country) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:stock_location) { create(:stock_location) }
  let!(:mug) { create(:product, name: "RoR Mug") }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:zone) { create(:zone) }
  let!(:user) { create(:user) }
  let!(:order) { OrderWalkthrough.up_to(:delivery) }

  context "when order is completed" do

    it 'sends order confirmation to flowdock on future order visitsa' do
      stub = create_request_stub(order)
      store = create_store

      allow_any_instance_of(Spree::CheckoutController).to receive_messages(:current_order => order)
      allow_any_instance_of(Spree::CheckoutController).to receive_messages(:try_spree_current_user => user)
      allow_any_instance_of(Spree::OrdersController).to receive_messages(:try_spree_current_user => user)

      visit spree.checkout_state_path(:delivery)
      click_button "Save and Continue"
      click_button "Save and Continue"

      expect(page).to have_content(Spree.t(:thank_you_for_your_order))
      expect(stub).to have_been_requested
    end

    it 'does not send order confirmation to flowdock' do
      stub = create_request_stub(order)
      store = create_store
      order = OrderWalkthrough.up_to(:complete)

      visit spree.order_path(order)
      expect(page).to_not have_content(Spree.t(:thank_you_for_your_order))
      expect(stub).not_to have_been_requested
    end

  end

  def create_store
    create(:store,
      name: 'Spree Test Store',
      url: 'www.example.org',
      mail_from_address: 'test@example.org')
  end

  def create_request_stub(order)
    Spree::FlowdockConfiguration.new.configure do |config|
      config.api_token_order_confirmation = 'test'
    end
    stub_request(:post, "https://api.flowdock.com/v1/messages/team_inbox/test")
      .with(
        :body => "source=Spree%20Test%20Store&format=html&from_address=test%40example.org&subject=New%20incoming%20order%20at%20Spree%20Test%20Store!&content=Order%20number%3A%20#{order.number}%3Cbr%2F%3ETotal%3A%20%24#{order.total}0&from_name=Spree%20Test%20Store&tags=test%2Corder%2Cincoming%2C#{order.number}&link=www.example.org%2Fde%2Fadmin%2Forders%2F#{order.number}%2Fedit",
        :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}
      )
      .to_return(
        :status => 200,
        :body => "",
        :headers => {}
      )
  end
end
