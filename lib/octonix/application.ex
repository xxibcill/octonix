defmodule Octonix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OctonixWeb.Telemetry,
      Octonix.Repo,
      {DNSCluster, query: Application.get_env(:octonix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Octonix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Octonix.Finch},
      # Start a worker by calling: Octonix.Worker.start_link(arg)
      # {Octonix.Worker, arg},
      # Start to serve requests, typically the last entry
      OctonixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Octonix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OctonixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
