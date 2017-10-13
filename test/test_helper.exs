if level = System.get_env("LOGGER_LEVEL") do
  level = String.to_existing_atom(level)
  Logger.configure(level: level)
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PriceTracker.Repo, :manual)
