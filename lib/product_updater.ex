defmodule PriceTracker.ProductUpdater do
  @moduledoc """
  Updates products using prices from external API
  """

  @typep action :: :updated | :inserted | :mismatch | :no_change
  @type status :: {action, ExternalProduct.t, Product.t} | :nothing

  alias PriceTracker.{Product, PastPrice, ExternalProduct, Repo}
  require Logger

  @doc "Given a new pricing information updates local Product"
  @spec update(ExternalProduct.t) :: status
  def update(external_product) do
    product =
      Repo.get_by(Product, external_product_id: external_product.id)

    external_name = external_product.name
    case product do
      nil ->
        insert(external_product)

      %Product{product_name: ^external_name} ->
        update(external_product, product)

      _mismatched ->
        {:mismatch, external_product, product}
    end
  end

  defp insert(%ExternalProduct{discontinued: true}) do
    :nothing
  end
  defp insert(external_product) do
    product =
      %{external_product_id: external_product.id,
        product_name: external_product.name,
        price: price_cents(external_product),
       }
       |> Product.changeset
       |> Repo.insert!

    {:inserted, external_product, product}
  end

  defp update(external_product, product) do
    price_cents = price_cents(external_product)
    if price_cents != product.price do
      product_changeset =
        product
        |> Product.changeset(%{price: price_cents(external_product)})

      price_changeset =
        %{product_id: product.id,
          price: product.price,
          percentage_change: percentage_change(external_product, product)
         }
         |> PastPrice.changeset

      {:ok, product} =
        Repo.transaction(fn ->
          Repo.insert!(price_changeset)
          Repo.update!(product_changeset)
        end)

      {:updated, external_product, product}
    else
      {:no_change, external_product, product}
    end
  end

  defp percentage_change(external_product, product) do
    (price_cents(external_product) - product.price)
    |> Kernel./(product.price)
    |> Kernel.*(100)
    |> Float.round(2)
  end

  defp price_cents(%ExternalProduct{price: price}) do
    round(price * 100)
  end

  @doc "Logs a given status"
  @spec log(status) :: :ok
  def log({action, _external, _product}) do
    case action do
      :no_change -> :ok
      :updated -> :ok
      :inserted -> Logger.info("[inserted]")
      :mismatch -> Logger.error("[mismatch]")
    end
  end
  def log(:nothing), do: :ok
end
