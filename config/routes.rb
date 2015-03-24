Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :flowdock_settings, only: [:update, :edit]
  end
end
