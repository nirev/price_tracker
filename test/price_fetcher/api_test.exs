defmodule PriceTracker.PriceFetcher.APITest do
  use ExUnit.Case, async: true

  alias PriceTracker.ExternalProduct
  alias PriceTracker.PriceFetcher

  setup do
    bypass = Bypass.open
    config = [
      host: "http://localhost:#{bypass.port}",
      api_key: "api-key"
    ]
    Application.put_env(:price_tracker, :api_fetcher, config)

    range = Date.range(Date.utc_today, Date.utc_today)

    {:ok, bypass: bypass, range: range}
  end

  test "error connecting", %{bypass: bypass, range: range} do
    Bypass.down(bypass)
    assert {:error, reason} = PriceFetcher.API.fetch(range)
    assert reason =~ "reason: :econnrefused"

    Bypass.up(bypass)
  end

  test "error response", %{bypass: bypass, range: range} do
    Bypass.expect bypass, fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end
    assert {:error, reason} = PriceFetcher.API.fetch(range)
    assert reason =~ "status_code: 500"
  end

  test "good response is parsed", %{bypass: bypass, range: range} do
    Bypass.expect bypass, "GET", "/pricing/records.json", fn conn ->
      Plug.Conn.resp(conn, 200, json_response())
    end

    assert {:ok, products} = PriceFetcher.API.fetch(range)
    assert Enum.count(products) == 2
    assert %ExternalProduct{
      id: "123456",
      name: "Nice Chair",
      price: 0.25,
      category: "home-furnishings",
      discontinued: false
    } in products

    assert %ExternalProduct{
      id: "234567",
      name: "Black & White TV",
      price: 0.77,
      category: "electronics",
      discontinued: true
    } in products
  end

  defp json_response do
    ~s({"productRecords": [
        {
          "id": 123456,
          "name": "Nice Chair",
          "price": ".25",
          "category": "home-furnishings",
          "discontinued": false
        },
        {
          "id": 234567,
          "name": "Black & White TV",
          "price": ".77",
          "category": "electronics",
          "discontinued": true
        }
      ]})
  end
end
