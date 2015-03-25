class Spree::FlowdockConfiguration < Spree::Preferences::Configuration
  preference :api_token_order_confirmation, :string, default: ''
end
