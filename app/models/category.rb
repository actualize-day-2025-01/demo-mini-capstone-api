class Category < ApplicationRecord
  has_many :category_products
  has_many :products, through: :category_products
  # def products
  #   result = []
  #   category_products.each do |category_product|
  #     result.push(Product.find_by(id: category_product.product_id))
  #   end
  #   result
  # end
end
