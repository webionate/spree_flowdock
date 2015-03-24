class Spree::FlowdockConfiguration < Spree::Preferences::Configuration
  preference :flow_api_token, :string, default: ''
end
