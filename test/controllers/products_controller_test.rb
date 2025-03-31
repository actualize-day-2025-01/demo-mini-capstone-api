require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: "Test", email: "test@test.com", password: "password", admin: true)
    post "/sessions.json", params: { email: "test@test.com", password: "password" }
  end

  test "index" do
    get "/products.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Product.count, data.length
  end

  test "show" do
    get "/products/#{Product.first.id}.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal [ "id", "name", "price", "tax", "total", "is_discounted?", "images", "primary_image_url", "description", "supplier", "categories", "created_at", "updated_at" ], data.keys
  end

  test "create" do
    assert_difference "Product.count", 1 do
      post "/products.json", params: { price: 1, name: "test product", description: "test description", image_url: "image.jpg", supplier_id: Supplier.first.id }
      data = JSON.parse(response.body)
      assert_response 200
    end

    assert_difference "Product.count", 0 do
      post "/products.json"
      assert_response 422
    end

    cookies.delete("user_id")
    post "/products.json"
    assert_response 401
  end

  test "update" do
    product = Product.first
    patch "/products/#{product.id}.json", params: { name: "Updated name" }
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal "Updated name", data["name"]
    assert_equal product.price.to_s, data["price"]
    assert_equal product.images, data["images"]
    assert_equal product.description, data["description"]

    patch "/products/#{product.id}.json", params: { price: -2 }
    assert_response 422

    cookies.delete("user_id")
    patch "/products/#{product.id}.json"
    assert_response 401
  end

  test "destroy" do
    assert_difference "Product.count", -1 do
      delete "/products/#{Product.first.id}.json"
      assert_response 200
    end

    cookies.delete("user_id")
    delete "/products/#{Product.first.id}.json"
    assert_response 401
  end
end
