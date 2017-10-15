defmodule PriceTracker.PriceFetcher.API do
  @moduledoc """
  Fetches products via API call
  """

  @behaviour PriceTracker.PriceFetcher

  alias PriceTracker.ExternalProduct

  @doc "Fetchs products within a date range"
  @impl PriceTracker.PriceFetcher
  def fetch(%Date.Range{first: first, last: last}) do
    with {:ok, host} <- get_config(:host),
         {:ok, api_key} <- get_config(:api_key) do
      params = [
        api_key: api_key,
        start_date: to_string(first),
        end_date: to_string(last)
      ]
      path = "/pricing/records.json"
      url = "#{host}#{path}"
      headers = [{"Accept", "application/json"}]

      url
      |> HTTPoison.get(headers, [params: params])
      |> parse_response()
    end
  end

  defp parse_response({:error, %{reason: reason}}) do
    {:error, "failed to get products from API. reason: #{inspect(reason)}"}
  end

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    products =
      body
      |> Poison.decode!(as: %{"productRecords" => [%ExternalProduct{}]})
      |> Map.get("productRecords")

    {:ok, products}
  end

  defp parse_response({:ok, %{status_code: code}}) do
    {:error, "failed to get products from API. status_code: #{code}"}
  end

  defp get_config(key) do
    case resolve_cfg(key) do
      nil -> {:error, "missing config: #{Atom.to_string(key)}"}
      value -> {:ok, value}
    end
  end

  defp resolve_cfg(key) do
    envkey = key |> Atom.to_string |> String.upcase
    case System.get_env("PRICE_TRACKER_#{envkey}") do
      nil ->
        Application.get_env(:price_tracker, :api_fetcher)[key]

      value -> value
    end
  end
end
