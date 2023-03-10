defmodule XDaysSober.DailyEmailTest do
  use ExUnit.Case, async: true

  import XDaysSober.Factory

  alias XDaysSober.DailyEmail
  alias XDaysSober.Person

  describe "generate/2" do
    test "correct email for person on day 1" do
      person = build_person_with_days_sober(%{}, 1)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "One day sober 🎉"

      assert email.text_body =~
               "Congratulations on taking the first step towards a sober lifestyle! The decision to get sober is not an easy one, and it takes a lot of courage and determination to make this change. Remember that you are not alone in this journey, and there are many resources and support systems available to help you along the way. Take it one day at a time, and be kind to yourself as you adjust to this new way of living. You are strong and capable, and you can do this. Keep up the good work!"
    end

    test "correct email for person on a normal day" do
      person = build_person_with_days_sober(%{}, 3)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "3 days sober 🎉"

      assert email.text_body =~
               "you did it! You are 3 days sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    end

    test "correct email for person after one week" do
      person = build_person_with_days_sober(%{}, 7)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "One week sober 🎆"

      assert email.text_body =~
               "Congratulations on one week of sobriety! You have already made a significant and positive change in your life, and should be proud of yourself for taking this important step. Remember that every day sober is a victory, and keep up the hard work. You are capable of living a fulfilling and healthy life without alcohol, and every day of sobriety brings you closer to achieving your goals. Keep going, and don't be afraid to reach out for support when you need it."
    end

    test "correct email for person after three weeks" do
      person = build_person_with_days_sober(%{}, 21)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "3 weeks sober 🎆"

      assert email.text_body =~
               "you did it! You are 3 weeks sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    end

    test "correct email for person after one month" do
      one_month_before = Timex.now() |> Timex.shift(months: -1) |> Timex.to_date()
      person = build(:person, sober_since: one_month_before)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "One month sober 💥"

      assert email.text_body =~
               "I am proud of you for taking control of your recovery and making the choice to stay sober for the past month. This is a significant accomplishment, and you deserve to feel good about it!"
    end

    test "correct email for person after three month" do
      one_month_before = Timex.now() |> Timex.shift(months: -3) |> Timex.to_date()
      person = build(:person, sober_since: one_month_before)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "3 months sober 💥"

      assert email.text_body =~
               "you did it! You are 3 months sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    end

    test "correct email for person after one year" do
      one_year_before = Timex.now() |> Timex.shift(years: -1) |> Timex.to_date()
      person = build(:person, sober_since: one_year_before)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "One year sober 🚀🚀🚀"

      assert email.text_body =~
               "you did it! You are 1 year sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    end

    test "correct email for person after three year" do
      one_year_before = Timex.now() |> Timex.shift(years: -3) |> Timex.to_date()
      person = build(:person, sober_since: one_year_before)
      sober_days = Person.calculate_sober_days(person)

      email = DailyEmail.generate(person, sober_days)

      assert email.subject == "3 years sober 🚀🚀🚀"

      assert email.text_body =~
               "you did it! You are 3 years sober! Keep up the hard work and dedication to your sobriety, you are making positive changes in your life and deserve to be proud of yourself."
    end
  end
end
