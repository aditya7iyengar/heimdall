defmodule Bifrost.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BifrostWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bifrost.PubSub},
      # Start the Endpoint (http/https)
      BifrostWeb.Endpoint,
      # Quantum scheduler
      Bifrost.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bifrost.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BifrostWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
