import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/x_days_sober start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :x_days_sober, XDaysSoberWeb.Endpoint, server: true
end

if config_env() == :prod do
  base_url =
    System.get_env("BASE_URL") ||
      raise """
      environment variable BASE_URL is missing.
      """

  from_email =
    System.get_env("FROM_EMAIL") ||
      raise """
      environment variable FROM_EMAIL is missing.
      """

  config :x_days_sober,
    base_url: base_url,
    from_email: from_email

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :x_days_sober, XDaysSober.Repo,
    # ssl: true,
    url: database_url,
    pool_size: pool_size,
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host =
    System.get_env("PHX_HOST") ||
      raise """
      environment variable PHX_HOST is missing.
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :x_days_sober, XDaysSoberWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  postmark_api_key =
    System.get_env("POSTMARK_API_KEY") ||
      raise """
      environment variable POSTMARK_API_KEY is missing.
      """

  config :x_days_sober, XDaysSober.Mailer, api_key: postmark_api_key
end
