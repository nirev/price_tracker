defmodule PriceTracker.Application do
  @moduledoc "Supervision tree for PriceTracker application"
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      PriceTracker.Repo
    ]

    opts = [strategy: :one_for_one, name: PriceTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
