defmodule PriceTrackerTest do
  use PriceTracker.DataCase

  alias PriceTracker.{FetcherMock,
                      PastPrice,
                      Product,
                      ExternalProduct,
                      Repo}
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

  describe "local product does not exist" do
    test "a product is inserted" do
      expect_chair()

      assert capture_log(fn ->
        PriceTracker.run
      end) =~ "[inserted]"

      assert [product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == "Nice Chair"
      assert product.price == 25
    end

    test "discontinued product is not inserted" do
      expect_chair(%{discontinued: true})

      assert capture_log(fn ->
        PriceTracker.run
      end) == ""

      refute Repo.one(Product)
    end
  end

  describe "local product exists" do
    test "price change" do
      expect_chair()
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Nice Chair",
                            price: 20})

      assert capture_log(fn ->
        PriceTracker.run
      end)

      assert [product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == "Nice Chair"
      assert product.price == 25

      assert [past_price] = Repo.all(PastPrice)
      assert past_price.percentage_change == 25.0
      assert past_price.price == 20
    end

    test "same price does nothing" do
      expect_chair()
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Nice Chair",
                            price: 25})

      assert capture_log(fn ->
        PriceTracker.run
      end)

      assert [product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == "Nice Chair"
      assert product.price == 25

      refute Repo.one(PastPrice)
    end

    test "name mismatch" do
      expect_chair()
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Not a chair",
                            price: 1000})

      assert capture_log(fn ->
        PriceTracker.run
      end) =~ "[mismatch]"
    end
  end

  defp expect_chair(override \\ %{}) do
    chair =
      %ExternalProduct{id: "123456",
                       name: "Nice Chair",
                       price: 0.25,
                       category: "home-furnishings",
                       discontinued: false}
                       |> Map.merge(override)

    expect(FetcherMock, :fetch, fn _range ->
      {:ok, [chair]}
    end)
  end
end
