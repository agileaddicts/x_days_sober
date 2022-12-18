defmodule XDaysSober.Repo do
  use Ecto.Repo,
    otp_app: :x_days_sober,
    adapter: Ecto.Adapters.Postgres
end
