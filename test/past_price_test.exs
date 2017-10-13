defmodule PriceTracker.PastPriceTest do
  use PriceTracker.DataCase

  alias PriceTracker.{PastPrice, Product}

  setup do
    product =
      %{external_product_id: "xx-1",
        product_name: "A Product",
        price: 1000
       }
       |> Product.changeset()
       |> Repo.insert!

    {:ok, product: product}
  end

  test "saves past price", %{product: product} do
    params = %{product_id: product.id,
               price: 1000,
               percentage_change: 0.1579
              }

    {:ok, past_price} =
      PastPrice.changeset(params)
      |> Repo.insert

    assert past_price.product_id == product.id
    assert past_price.percentage_change == params.percentage_change
    assert product.price == params.price
  end

  test "validates foreign key" do
    params = %{product_id: -1,
               price: 1000,
               percentage_change: 0.1579
              }

    {:error, changeset} =
      PastPrice.changeset(params)
      |> Repo.insert

    errors = errors_on(changeset) |> Map.keys
    assert :product_id in errors
  end
end
