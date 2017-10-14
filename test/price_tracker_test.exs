defmodule PriceTrackerTest do
  use PriceTracker.DataCase

  alias PriceTracker.{FetcherMock, Product, ExternalProduct, Repo}
  import Mox
  import ExUnit.CaptureLog

  test "failed to fetch" do
    FetcherMock
    |> expect(:fetch, fn _range ->
      {:error, "failed to fetch (oh no!)"}
    end)

    assert capture_log(fn ->
      assert :error = PriceTracker.run
    end) =~ "[error] failed to fetch (oh no!)"
  end

  @tag skip: true
  test "a product is inserted" do
    FetcherMock
    |> expect(:fetch, fn _range ->
      products = [%ExternalProduct{id: "123456",
                                   name: "Nice Chair",
                                   price: 0.25,
                                   category: "home-furnishings",
                                   discontinued: false}]
      {:ok, products}
    end)

    PriceTracker.run

    assert [product] = Repo.all(Product)
    assert product.external_product_id == "123456"
    assert product.name == "Nice Chair"
    assert product.price == 25
  end
end
