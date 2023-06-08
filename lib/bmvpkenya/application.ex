defmodule Bmvpkenya.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BmvpkenyaWeb.Telemetry,
      # Start the Ecto repository
      Bmvpkenya.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bmvpkenya.PubSub},
      # Start Finch
      {Finch, name: Bmvpkenya.Finch},
      # Start the Endpoint (http/https)
      BmvpkenyaWeb.Endpoint
      # Start a worker by calling: Bmvpkenya.Worker.start_link(arg)
      # {Bmvpkenya.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bmvpkenya.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BmvpkenyaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
