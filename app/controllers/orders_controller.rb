class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders
    # @orders = []
    # Order.all.each do |order|
    #   if order.user_id == current_user.id
    #     @orders.push(order)
    #   end
    # end
    render :index
  end

  def create
    carted_products = CartedProduct.where(user_id: current_user.id, status: "carted")

    calculated_subtotal = 0
    calculated_tax = 0
    index = 0
    while index < carted_products.length
      carted_product = carted_products[index]
      calculated_subtotal += carted_product.product.price * carted_product.quantity
      calculated_tax += carted_product.product.tax * carted_product.quantity
      index += 1
    end
    calculated_total = calculated_subtotal + calculated_tax

    @order = Order.create(
      user_id: current_user.id,
      subtotal: calculated_subtotal,
      tax: calculated_tax,
      total: calculated_total,
    )
    if @order.valid?

      index = 0
      while index < carted_products.length
        carted_product = carted_products[index]
        carted_product.update(status: "purchased", order_id: @order.id)
        index += 1
      end

      render :show
    else
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def show
    @order = current_user.orders.find_by(id: params[:id])
    render :show
  end
end
