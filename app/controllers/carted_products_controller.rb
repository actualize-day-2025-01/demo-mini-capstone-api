class CartedProductsController < ApplicationController
  def index
    @carted_products = CartedProduct.where(user_id: current_user.id, status: "carted")
    render json: @carted_products
  end

  def create
    @carted_product = CartedProduct.create(
      user_id: current_user.id,
      product_id: params[:product_id],
      quantity: params[:quantity],
      status: "carted",
      order_id: nil
    )
    if @carted_product.valid?
      render json: @carted_product
    else
      render json: { errors: @carted_product.errors.full_messages }, status: 422
    end
  end
end
