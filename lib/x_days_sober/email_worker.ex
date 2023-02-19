defmodule XDaysSober.EmailWorker do
  @moduledoc false

  use Oban.Worker

  alias XDaysSober.DailyEmail
  alias XDaysSober.Mailer
  alias XDaysSober.Person
  alias XDaysSober.PersonRepo

  require Logger

  @impl Oban.Worker
  def perform(_job) do
    Logger.info("Start running EmailWorker")

    for person <- PersonRepo.list_subscribed() do
      sober_days = Person.calculate_sober_days(person)

      timezone_hour =
        person.timezone
        |> Timex.now()
        |> Timex.format("%H", :strftime)
        |> then(fn {:ok, timezone_hour_string} -> String.to_integer(timezone_hour_string) end)

      if !person.unsubscribed && sober_days.days > 0 && timezone_hour == 5 do
        Logger.info("Sending email for person #{person.uuid} and day #{sober_days.days}")

        person
        |> DailyEmail.generate(sober_days)
        |> Mailer.deliver()
      end
    end

    :ok
  end
end
