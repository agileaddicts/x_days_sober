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

      assert Person.calculate_sober_days(person) == 0
    end

    test "correct calculation with Person" do
      timezone = "Etc/UTC"

      person = build_person_with_days_sober(%{timezone: timezone}, 5)

      assert Person.calculate_sober_days(person) == 5
    end
  end
end
