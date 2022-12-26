# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule XDaysSober.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias XDaysSoberWeb.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      XDaysSober.Repo,
      # Start the Telemetry supervisor
      XDaysSoberWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: XDaysSober.PubSub},
      # Start the Endpoint (http/https)
      Endpoint,
      # Start a worker by calling: XDaysSober.Worker.start_link(arg)
      # {XDaysSober.Worker, arg}
      {Oban, Application.fetch_env!(:x_days_sober, Oban)},
      {Finch, name: Swoosh.Finch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XDaysSober.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
