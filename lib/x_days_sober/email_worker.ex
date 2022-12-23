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

      if days > 0 do
        day_text =
          case days do
            1 -> "1 day"
            days -> "#{days} days"
          end

        new()
        |> to({name, person.email})
        |> from({"X Days Sober", "xdayssober@boo.sh"})
        |> subject("🎉 #{day_text} sober 🎉")
        |> text_body(
          "Hey #{name},\n\nyou did it! You are #{day_text} sober! You have every reason to be proud about this number.\n\nUntil tomorrow,\nSebastian\n\nChange your settings at: #{build_url("/p/#{person.uuid}")}"
        )
        |> Mailer.deliver()
      end
    end

    :ok
  end

  defp build_url(path) do
    base_url = Application.fetch_env!(:x_days_sober, :base_url)
    base_url <> path
  end
end
