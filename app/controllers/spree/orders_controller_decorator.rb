Spree::OrdersController.class_eval do
  after_filter :push_order_confirmation, only: [:show]

  private

  def push_order_confirmation
    if flash[:order_completed] && @order.present?
      Spree::FlowdockOrderConfirmation.new(@order).push
    end
  end

end
