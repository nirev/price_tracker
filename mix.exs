defmodule PriceTracker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :price_tracker,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:poison, "~> 3.1"},
      {:mox, "~> 0.1.0", only: :test},
    ]
  end
end
