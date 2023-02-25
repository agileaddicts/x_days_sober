defmodule XDaysSober.DailyEmail do
  @moduledoc false

  use XDaysSoberWeb, :verified_routes

  import Swoosh.Email

  alias XDaysSober.DailyEmailTemplate

  require Logger

  @subjects %{
    years: %{
      1 => "One year sober 🚀🚀🚀"
    },
    months: %{
      1 => "One month sober 💥"
    },
    weeks: %{
      1 => "One week sober 🎆"
    },
    days: %{
      1 => "One day sober 🎉"
    }
  }

  @bodys %{
    years: %{
      1 =>
        "you did it! You are 1 year sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    },
    months: %{
      1 =>
        "I am proud of you for taking control of your recovery and making the choice to stay sober for the past month. This is a significant accomplishment, and you deserve to feel good about it!"
    },
    weeks: %{
      1 =>
        "Congratulations on one week of sobriety! You have already made a significant and positive change in your life, and should be proud of yourself for taking this important step. Remember that every day sober is a victory, and keep up the hard work. You are capable of living a fulfilling and healthy life without alcohol, and every day of sobriety brings you closer to achieving your goals. Keep going, and don't be afraid to reach out for support when you need it."
    },
    days: %{
      1 =>
        "Congratulations on taking the first step towards a sober lifestyle! The decision to get sober is not an easy one, and it takes a lot of courage and determination to make this change. Remember that you are not alone in this journey, and there are many resources and support systems available to help you along the way. Take it one day at a time, and be kind to yourself as you adjust to this new way of living. You are strong and capable, and you can do this. Keep up the good work!"
    }
  }

  def generate(person, sober_days) do
    name = person.name || person.email

    subject_text = subject_text(sober_days)
    text_body_text = text_body_text(sober_days)

    logo_url = url(~p"/images/logo.png")

    personal_affirmation_url = url(~p"/pa/#{person.uuid}/#{sober_days.days}")

    person_detail_url = url(~p"/p/#{person.uuid}")

    person_unsubscribe_url = url(~p"/p/#{person.uuid}?unsubscribe=1")

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

  defp subject_text(%{years: years}) when years > 0 do
    Map.get(@subjects.years, years, "#{years} years sober 🚀🚀🚀")
  end

  defp subject_text(%{months: months}) when months > 0 do
    Map.get(@subjects.months, months, "#{months} months sober 💥")
  end

  defp subject_text(%{weeks: weeks}) when weeks > 0 do
    Map.get(@subjects.weeks, weeks, "#{weeks} weeks sober 🎆")
  end

  defp subject_text(%{days: days}) do
    Map.get(@subjects.days, days, "#{days} days sober 🎉")
  end

  defp text_body_text(%{years: years}) when years > 0 do
    Map.get(
      @bodys.years,
      years,
      "you did it! You are #{years} years sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    )
  end

  defp text_body_text(%{months: months}) when months > 0 do
    Map.get(
      @bodys.months,
      months,
      "you did it! You are #{months} months sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    )
  end

  defp text_body_text(%{weeks: weeks}) when weeks > 0 do
    Map.get(
      @bodys.weeks,
      weeks,
      "you did it! You are #{weeks} weeks sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    )
  end

  defp text_body_text(%{days: days}) do
    Map.get(
      @bodys.days,
      days,
      "you did it! You are #{days} days sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    )
  end
end
