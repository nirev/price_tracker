defmodule PriceTracker.ExternalProduct do
  @moduledoc """
  A Product return by external vendor
  """

  @type t :: %{id: integer(),
               name: String.t,
               price: float(),
               category: String.t,
               discontinued: boolean()}

  @derive [Poison.Encoder]
  defstruct [:id,
             :name,
             :price,
             :category,
             :discontinued]

  defimpl Poison.Decoder do
    def decode(external_product, _options) do
      %{price: price, id: id} = external_product

      external_product
      |> Map.put(:price, parse_price(price))
      |> Map.put(:id, id && to_string(id))
    end

    defp parse_price(nil), do: nil
    defp parse_price("." <> rest), do: String.to_float("0.#{rest}")
    defp parse_price(price), do: String.to_float(price)
  end
end
