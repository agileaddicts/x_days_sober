defmodule XDaysSober.PersonTest do
  use ExUnit.Case, async: true

  alias Timex.Duration
  alias XDaysSober.Person

  describe "changeset/2" do
    # Has to be implemented
    @tag :skip
    test "valid changeset" do
    end
  end

  describe "calculate_sober_days/1" do
    test "correct calculation with new Person" do
      timezone = "Etc/UTC"

      person = %Person{
        timezone: timezone,
        sober_since:
          timezone
          |> Timex.now()
          |> Timex.to_date()
      }

      assert Person.calculate_sober_days(person) == 0
    end

    test "correct calculation with Person" do
      timezone = "Etc/UTC"

      person = %Person{
        timezone: timezone,
        sober_since:
          timezone
          |> Timex.now()
          # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
          |> Timex.subtract(Duration.from_days(5))
          |> Timex.to_date()
      }

      assert Person.calculate_sober_days(person) == 5
    end
  end
end
