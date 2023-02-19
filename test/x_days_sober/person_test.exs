defmodule XDaysSober.PersonTest do
  use ExUnit.Case, async: true

  import XDaysSober.Factory

  alias XDaysSober.Person

  describe "changeset/2" do
    # Has to be implement
    @tag :skip
    test "valid changeset" do
    end
  end

  describe "calculate_sober_days/1" do
    test "correct calculation with new Person" do
      timezone = "Etc/UTC"

      person = build_person_with_days_sober(%{timezone: timezone}, 0)

      sober_days = Person.calculate_sober_days(person)

      assert sober_days.days == 0
      assert sober_days.weeks == 0
      assert sober_days.months == 0
    end

    test "correct calculation with Person and a few days sober" do
      timezone = "Etc/UTC"

      person = build_person_with_days_sober(%{timezone: timezone}, 5)

      sober_days = Person.calculate_sober_days(person)

      assert sober_days.days == 5
      assert sober_days.weeks == -1
      assert sober_days.months == -1
    end

    test "correct calculation with Person and one week sober" do
      timezone = "Etc/UTC"

      person = build_person_with_days_sober(%{timezone: timezone}, 7)

      sober_days = Person.calculate_sober_days(person)

      assert sober_days.days == 7
      assert sober_days.weeks == 1
    end

    test "correct calculation with Person and one month sober" do
      timezone = "Etc/UTC"

      one_month_before = Timex.now() |> Timex.shift(months: -1) |> Timex.to_date()
      person = build(:person, timezone: timezone, sober_since: one_month_before)

      sober_days = Person.calculate_sober_days(person)

      assert sober_days.months == 1
    end

    test "correct calculation with Person and one year sber" do
      timezone = "Etc/UTC"

      one_month_before = Timex.now() |> Timex.shift(years: -1) |> Timex.to_date()
      person = build(:person, timezone: timezone, sober_since: one_month_before)

      sober_days = Person.calculate_sober_days(person)

      assert sober_days.years == 1
    end
  end
end
