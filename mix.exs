defmodule PriceTracker.Mixfile do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :price_tracker,
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [ flags: [:error_handling, :race_conditions],
                  remove_defaults: [:unknown]],

      # Docs
      name: "Price Tracker Test",
      docs: [output: "./docs",
             canonical: "https://nirev.github.io/price_tracker",
             source_url: "https://github.com/nirev/price_tracker"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp aliases do
    [
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
      "analysis": ["credo --strict", "dialyzer"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PriceTracker.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:earmark, "~> 1.1", only: :dev},
      {:ecto, "~> 2.1"},
      {:ex_doc, "~> 0.16", only: :dev},
      {:httpoison, "~> 0.13"},
      {:mox, "~> 0.2.0", only: :test},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
    ]
  end
end
