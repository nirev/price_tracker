defmodule PriceTracker.Product do
  @moduledoc "A Product ;)"

  @type t :: %__MODULE__{}
  @type changeset_t :: %Ecto.Changeset{data: t}

  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :external_product_id, :string
    field :price, :integer
    field :product_name, :string

    has_many :past_prices, PriceTracker.PastPrice

    timestamps()
  end

  @fields ~w(external_product_id price product_name)a

  @doc "Creates a Product changeset"
  @spec changeset(t, map) :: changeset_t
  def changeset(product \\ %__MODULE__{}, params) do
    product
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
