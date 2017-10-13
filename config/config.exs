use Mix.Config

config :price_tracker, ecto_repos: [PriceTracker.Repo]

config :price_tracker, PriceTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "price_tracker",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

