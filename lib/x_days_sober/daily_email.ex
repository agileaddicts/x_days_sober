defmodule XDaysSober.DailyEmail do
  @moduledoc false

  import Swoosh.Email

  alias XDaysSoberWeb.Endpoint
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  require Logger

  @subjects %{
    1 => "One day sober 🎉",
    7 => "One week sober 🎉",
    10 => "Double digits! 10 days sober 🎆"
  }

  @text_bodies %{
    1 =>
      "Congratulations on taking the first step towards a sober lifestyle! The decision to get sober is not an easy one, and it takes a lot of courage and determination to make this change. Remember that you are not alone in this journey, and there are many resources and support systems available to help you along the way. Take it one day at a time, and be kind to yourself as you adjust to this new way of living. You are strong and capable, and you can do this. Keep up the good work!",
    7 =>
      "Congratulations on one week of sobriety! You have already made a significant and positive change in your life, and should be proud of yourself for taking this important step. Remember that every day sober is a victory, and keep up the hard work. You are capable of living a fulfilling and healthy life without alcohol, and every day of sobriety brings you closer to achieving your goals. Keep going, and don't be afraid to reach out for support when you need it.",
    10 =>
      "This is awesome! You stayed sober for 10 days. I got a short poem for you:\n\nTen days sober, feeling fine\nNo more hangovers, no more wine\nWith each passing day, the journey's rough\nBut each sober moment is more than enough\n\nI hope you liked it."
  }

  def generate(person, days) do
    name = person.name || person.email

    url =
      Endpoint
      |> Helpers.live_path(
        PersonLive,
        person.uuid
      )
      |> build_url()

    new()
    |> to({name, person.email})
    |> from({"X Days Sober", "xdayssober@boo.sh"})
    |> subject(subject_text(days))
    |> text_body(
      "Hey #{name},\n\n#{text_body_text(days)}\n\nUntil tomorrow,\nSebastian\n\nChange your settings at: #{url}"
    )
  end

  defp subject_text(days) do
    Map.get(@subjects, days, "#{days} days sober 🎉")
  end

  defp text_body_text(days) do
    Map.get(
      @text_bodies,
      days,
      "you did it! You are #{days} days sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    )
  end

  defp build_url(path) do
    base_url = Application.fetch_env!(:x_days_sober, :base_url)
    base_url <> path
  end
end
