defmodule PriceTracker.ProductUpdaterTest do
  use PriceTracker.DataCase

  alias PriceTracker.{PastPrice,
                      Product,
                      ProductUpdater,
                      ExternalProduct,
                      Repo}

  setup do
    chair =
      %ExternalProduct{id: "123456",
                       name: "Nice Chair",
                       price: 0.25,
                       category: "home-furnishings",
                       discontinued: false}

    {:ok, chair: chair}
  end

  describe "local product does not exist" do
    test "a product is inserted", %{chair: chair} do
      assert {:inserted, ^chair, product} =
        ProductUpdater.update(chair)

      assert [^product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == chair.name
      assert product.price == round(chair.price*100)
    end

    test "discontinued product is not inserted", %{chair: chair} do
      chair = %ExternalProduct{chair | discontinued: true}

      assert :nothing = ProductUpdater.update(chair)
      refute Repo.one(Product)
    end
  end

  describe "local product exists" do
    test "price change", %{chair: chair} do
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Nice Chair",
                            price: 20})

      assert {:updated, ^chair, product} =
        ProductUpdater.update(chair)

      assert [^product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == "Nice Chair"
      assert product.price == 25

      assert [past_price] = Repo.all(PastPrice)
      assert past_price.percentage_change == 25.0
      assert past_price.price == 20
    end

    test "same price does nothing", %{chair: chair} do
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Nice Chair",
                            price: 25})

      assert {:no_change, ^chair, product} =
        ProductUpdater.update(chair)

      assert [^product] = Repo.all(Product)
      assert product.external_product_id == "123456"
      assert product.product_name == "Nice Chair"
      assert product.price == 25

      refute Repo.one(PastPrice)
    end

    test "name mismatch", %{chair: chair} do
      Repo.insert!(%Product{external_product_id: "123456",
                            product_name: "Not a chair",
                            price: 1000})

      assert {:mismatch, ^chair, product} =
        ProductUpdater.update(chair)
      assert product.product_name == "Not a chair"
    end
  end

end
