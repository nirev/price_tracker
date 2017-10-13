use Mix.Config

config :price_tracker, PriceTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "price_tracker",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :price_tracker, fetcher: PriceTracker.FetcherMock
