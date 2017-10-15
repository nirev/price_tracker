defmodule PriceTracker.PriceFetcher do
  @moduledoc """
  Behavior for fetching Products
  """

  @type error :: {:error, reason :: String.t}

  @doc "Fetchs products within a date range"
  @callback fetch(range :: Date.Range.t) :: {:ok, [ExternalProduct.t]} | error
end
