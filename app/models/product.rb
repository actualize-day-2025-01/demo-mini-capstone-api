class Product < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :description, length: { in: 1..500 }

  belongs_to :supplier
  # validates :supplier_id, presence: true
  # def supplier
  #   Supplier.find_by(id: supplier_id)
  # end

  has_many :images
  has_many :orders
  has_many :category_products
  has_many :categories, through: :category_products

  def is_discounted?
    price <= 10
  end

  def tax
    price * 0.09
  end

  def total
    price + tax
  end

  def primary_image_url
    if images.length > 0
      images[0].url
    else
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
    end
  end
end
