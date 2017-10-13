defmodule PriceTracker.Repo.Migrations.AddProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :external_product_id, :string
      add :price, :integer
      add :product_name, :string

      timestamps()
    end
  end
end
