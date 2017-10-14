defmodule PriceTracker.ProductUpdater do
  @moduledoc """
  Updates products using prices from external API
  """

  @type status :: {:updated | :inserted | :mismatch, ExternalProduct.t, Product.t}

  alias PriceTracker.{Product}
  require Logger

  @doc "Given a new pricing information updates local Product"
  @spec update(ExternalProduct.t) :: status
  def update(external_product) do
    updated = %Product{}
    {:updated, external_product, updated}
  end

  @doc "Logs a given status"
  @spec log(status) :: :ok
  def log({action, _external, _product}) do
    case action do
      :updated -> :ok
      :inserted -> Logger.info("[inserted]")
      :mismatch -> Logger.error("[mismatch]")
    end
  end
end

