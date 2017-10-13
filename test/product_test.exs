defmodule PriceTracker.ProductTest do
  use PriceTracker.DataCase

  alias PriceTracker.Product

  test "saves product" do
    params = %{external_product_id: "xx-1",
               product_name: "A Product",
               price: 1000}

    {:ok, product} =
      Product.changeset(params)
      |> Repo.insert

    assert product.product_name == "A Product"
    assert product.external_product_id == "xx-1"
    assert product.price == 1000
  end

  test "validates presence of fields" do
    changeset = Product.changeset(%{})
    errors = errors_on(changeset) |> Map.keys

    refute changeset.valid?
    assert :external_product_id in errors
    assert :product_name in errors
    assert :price in errors
  end
end
