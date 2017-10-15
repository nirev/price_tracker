defmodule PriceTracker do
  @moduledoc """
  PriceTracker
  """

  alias PriceTracker.ProductUpdater
  require Logger

  @doc """
  Runs the pricing tracker update
  """
  def run do
    with fetcher <- Application.get_env(:price_tracker, :fetcher),
         today <- Date.utc_today,
         month_ago <- Timex.shift(today, months: -1),
         range <- Date.range(month_ago, today),
         {:ok, products} <- fetcher.fetch(range) do
      products
      |> Enum.map(&ProductUpdater.update/1)
      |> Enum.map(&ProductUpdater.log/1)

      :ok
    else
      {:error, reason} ->
        Logger.error(reason)
        :error
    end
  end
end
