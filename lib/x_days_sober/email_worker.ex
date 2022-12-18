defmodule XDaysSober.EmailWorker do
  use Oban.Worker

  import Swoosh.Email

  alias XDaysSober.Mailer
  alias XDaysSober.Person
  alias XDaysSober.Repo

  @impl Oban.Worker
  def perform(_) do
    for person <- Repo.all(Person) do
      name = person.name || person.email

      days =
        person.timezone
        |> Timex.now()
        |> Timex.to_date()
        |> Timex.diff(person.sober_since, :days)

      day_text =
        case days do
          1 -> "1 day"
          days -> "#{days} days"
        end

      if days > 0 do
        new()
        |> to({name, person.email})
        |> from({"X Days Sober", "steps@xdayssober.com"})
        |> subject("🎉 #{day_text} sober 🎉")
        |> text_body(
          "Hey #{name},\n\nyou did it! You are #{day_text} sober! You have every reason to be proud about this number.\n\nUntil tomorrow,\nSebastian"
        )
        |> Mailer.deliver()
      end
    end

    :ok
  end
end
