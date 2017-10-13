defmodule PriceTracker.PastPrice do
  @moduledoc "Past Prices for a `PriceTracker.Product`"

  @type t :: %__MODULE__{}
  @type changeset_t :: %Ecto.Changeset{data: t}

  use Ecto.Schema
  import Ecto.Changeset

  schema "past_prices" do
    field :price, :integer
    field :percentage_change, :float

    belongs_to :product, PriceTracker.Product

    timestamps()
  end

  @fields ~w(product_id price percentage_change)a

  @doc "Creates a PastPrice changeset"
  @spec changeset(t, map) :: changeset_t
  def changeset(price \\ %__MODULE__{}, params) do
    price
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:product_id)
  end
end
