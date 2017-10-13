defmodule PriceTracker.PriceFetcher do
  @moduledoc """
  Behavior for fetching Products
  """

  @doc "Fetchs products within a date range"
  @callback fetch(Date.Range.t) :: [ExternalProduct.t]
end
