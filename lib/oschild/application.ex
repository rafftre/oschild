defmodule Oschild.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OschildWeb.Telemetry,
      Oschild.Repo,
      {DNSCluster, query: Application.get_env(:oschild, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Oschild.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Oschild.Finch},
      # Start a worker by calling: Oschild.Worker.start_link(arg)
      # {Oschild.Worker, arg},
      # Start to serve requests, typically the last entry
      OschildWeb.Endpoint,
      Oschild.Child.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oschild.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OschildWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
