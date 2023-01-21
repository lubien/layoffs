defmodule Layoffs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LayoffsWeb.Telemetry,
      # Start the Ecto repository
      Layoffs.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Layoffs.PubSub},
      # Start Finch
      {Finch, name: Layoffs.Finch},
      # Start the Endpoint (http/https)
      LayoffsWeb.Endpoint
      # Start a worker by calling: Layoffs.Worker.start_link(arg)
      # {Layoffs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Layoffs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LayoffsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
