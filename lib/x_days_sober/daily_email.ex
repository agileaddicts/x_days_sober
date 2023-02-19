defmodule XDaysSober.DailyEmail do
  @moduledoc false

  import Swoosh.Email

  alias XDaysSober.DailyEmailTemplate
  alias XDaysSoberWeb.Endpoint
  alias XDaysSoberWeb.PersonalAffirmationLive
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  require Logger

  def generate(person, sober_days) do
    name = person.name || person.email

    subject_text = subject_text(sober_days)
    text_body_text = text_body_text(sober_days)

    logo_url =
      Endpoint
      |> Helpers.static_path("/images/logo.png")
      |> build_url()

    personal_affirmation_url =
      Endpoint
      |> Helpers.live_path(
        PersonalAffirmationLive,
        person.uuid,
        sober_days.days
      )
      |> build_url()

    person_detail_url =
      Endpoint
      |> Helpers.live_path(
        PersonLive,
        person.uuid
      )
      |> build_url()

    person_unsubscribe_url =
      Endpoint
      |> Helpers.live_path(
        PersonLive,
        person.uuid,
        unsubscribe: 1
      )
      |> build_url()

    html =
      DailyEmailTemplate.render(
        logo_url: logo_url,
        subject: subject_text,
        name: name,
        text_body_text: text_body_text,
        personal_affirmation_url: personal_affirmation_url,
        person_detail_url: person_detail_url,
        person_unsubscribe_url: person_unsubscribe_url
      )

    new()
    |> to({name, person.email})
    |> from({"X Days Sober", Application.fetch_env!(:x_days_sober, :from_email)})
    |> subject(subject_text)
    |> html_body(html)
    |> text_body(
      "Hey #{name},\n\n#{text_body_text}\n\nDo you want to write an affirmation for others who are at the same point: #{personal_affirmation_url}\n\nUntil tomorrow,\nSebastian\n\nChange your settings at: #{person_detail_url}\n\nUnsubscribe at: #{person_unsubscribe_url}"
    )
  end

  defp subject_text(%{years: years}) when years == 1, do: "One year sober 🚀🚀🚀"
  defp subject_text(%{years: years}) when years > 0, do: "#{years} years sober 🚀🚀🚀"

  defp subject_text(%{months: months}) when months == 1, do: "One month sober 💥"
  defp subject_text(%{months: months}) when months > 0, do: "#{months} months sober 💥"

  defp subject_text(%{weeks: weeks}) when weeks == 1, do: "One week sober 🎆"
  defp subject_text(%{weeks: weeks}) when weeks == 2, do: "Two weeks sober 🎆"
  defp subject_text(%{weeks: weeks}) when weeks == 3, do: "Three weeks sober 🎆"
  defp subject_text(%{weeks: weeks}) when weeks == 4, do: "Four weeks sober 🎆"

  defp subject_text(%{weeks: weeks}) when weeks > 0, do: "#{weeks} weeks sober 🎆"

  defp subject_text(%{days: days}) when days == 1, do: "One day sober 🎉"
  defp subject_text(%{days: days}), do: "#{days} days sober 🎉"

  defp text_body_text(%{weeks: weeks}) when weeks == 1,
    do:
      "Congratulations on one week of sobriety! You have already made a significant and positive change in your life, and should be proud of yourself for taking this important step. Remember that every day sober is a victory, and keep up the hard work. You are capable of living a fulfilling and healthy life without alcohol, and every day of sobriety brings you closer to achieving your goals. Keep going, and don't be afraid to reach out for support when you need it."

  defp text_body_text(%{weeks: weeks}) when weeks == 2,
    do:
      "I am proud of you for taking control of your recovery and making the choice to stay sober for the past two weeks. This is a significant accomplishment, and you deserve to feel good about it!"

  defp text_body_text(%{weeks: weeks}) when weeks == 3,
    do:
      "Wow! You are 3 weeks sober, that's awesome. One tip for someone who is abstinent from alcohol is to find a support system. It can be helpful to surround yourself with people who are also in recovery or who support your decision to live a sober lifestyle. This can include friends, family members, a therapist, or a support group such as Alcoholics Anonymous. Having people to talk to and share your experiences with can provide motivation and accountability as you continue on your journey of recovery."

  defp text_body_text(%{weeks: weeks}) when weeks == 4,
    do:
      "You did not drink any alcohol for a full 4 weeks. I got a tip to keep up the good work: It can be helpful to have a plan in place for how to handle cravings or difficult situations that may arise. This could involve finding healthy ways to cope with stress, such as exercising or practicing relaxation techniques, or having a list of phone numbers to call when you need support. Remember that recovery is a process, and it's important to be patient and kind to yourself as you continue to learn and grow."

  defp text_body_text(%{days: days}) when days == 1,
    do:
      "Congratulations on taking the first step towards a sober lifestyle! The decision to get sober is not an easy one, and it takes a lot of courage and determination to make this change. Remember that you are not alone in this journey, and there are many resources and support systems available to help you along the way. Take it one day at a time, and be kind to yourself as you adjust to this new way of living. You are strong and capable, and you can do this. Keep up the good work!"

  defp text_body_text(%{days: days}),
    do:
      "you did it! You are #{days} days sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."

  defp build_url(path) do
    base_url = Application.fetch_env!(:x_days_sober, :base_url)
    base_url <> path
  end
end
