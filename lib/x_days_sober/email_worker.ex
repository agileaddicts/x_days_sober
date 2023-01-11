defmodule XDaysSober.EmailWorker do
  @moduledoc false

  use Oban.Worker

  alias XDaysSober.DailyEmail
  alias XDaysSober.Mailer
  alias XDaysSober.Person
  alias XDaysSober.Repo

  require Logger

  @impl Oban.Worker
  def perform(_job) do
    Logger.info("Start running EmailWorker")

    for person <- Repo.all(Person) do
      days = Person.calculate_sober_days(person)

      if !person.unsubscribed && days > 0 do
        Logger.info("Sending email for person #{person.uuid} and day #{days}")

        person
        |> DailyEmail.generate(days)
        |> Mailer.deliver()
      end
    end

    :ok
  end
end
