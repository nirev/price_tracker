use Mix.Config

config :price_tracker, ecto_repos: [PriceTracker.Repo]

config :price_tracker, PriceTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "price_tracker",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :price_tracker, fetcher: PriceTracker.PriceFetcher.API

config :price_tracker, :api_fetcher,
  host: "https://omegapricinginc.com"

config :logger, level: :info

if :test == Mix.env do
  import_config "test.exs"
end
