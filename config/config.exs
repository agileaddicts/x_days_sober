# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :x_days_sober,
  ecto_repos: [XDaysSober.Repo],
  base_url: "http://localhost:4000",
  from_email: "dev@xdayssober.local"

# Configures the endpoint
config :x_days_sober, XDaysSoberWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: XDaysSoberWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: XDaysSober.PubSub,
  live_view: [signing_salt: "7k8yknfJ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :x_days_sober, XDaysSober.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Finch

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :x_days_sober, Oban,
  repo: XDaysSober.Repo,
  plugins: [
    Oban.Plugins.Pruner,
    {Oban.Plugins.Cron,
     crontab: [
       {"0 * * * *", XDaysSober.EmailWorker}
     ]}
  ],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
