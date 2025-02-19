class ProductsController < ApplicationController
  def all_products
    @products = Product.all
    render template: "products/index"
  end

  def single_product
    @product = Product.find_by(id: params["id"])
    render template: "products/show"
  end
end
