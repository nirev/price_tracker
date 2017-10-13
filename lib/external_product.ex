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
end
