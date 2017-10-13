defmodule PriceTracker.Repo.Migrations.AddPastPrices do
  use Ecto.Migration

  def change do
    create table(:past_prices) do
      add :product_id, references(:products)
      add :price, :integer
      add :percentage_change, :float

      timestamps()
    end
  end
end
