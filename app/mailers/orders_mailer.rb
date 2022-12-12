class OrdersMailer < ApplicationMailer
  default from: 'shopkeeper@coffeeshop.com'

  def order_prepaired
    @name = params[:name]
    @email = params[:email]

    mail to: @email
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end
