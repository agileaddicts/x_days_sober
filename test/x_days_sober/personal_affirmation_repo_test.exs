defmodule XDaysSober.PersonalAffirmationRepoTest do
  use XDaysSober.DataCase, async: true

  import XDaysSober.Factory

  alias Timex.Duration
  alias XDaysSober.PersonalAffirmation
  alias XDaysSober.PersonalAffirmationRepo
  alias XDaysSober.Repo

  describe "create/2" do
    test "correct insert with unique person and day" do
      person =
        insert!(:person,
          sober_since:
            "Europe/Vienna"
            |> Timex.now()
            # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
            |> Timex.subtract(Duration.from_days(3))
            |> Timex.to_date()
        )

      day = 1
      {:ok, personal_affirmation} = PersonalAffirmationRepo.create(person, day)

      assert personal_affirmation.id
      assert personal_affirmation.uuid
      assert personal_affirmation.person_id == person.id
      assert personal_affirmation.day == day
      refute personal_affirmation.text
      refute personal_affirmation.approved

      assert Repo.get(PersonalAffirmation, personal_affirmation.id)
    end

    test "correct insert with unique person and second day" do
      person =
        insert!(:person,
          sober_since:
            "Europe/Vienna"
            |> Timex.now()
            # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
            |> Timex.subtract(Duration.from_days(3))
            |> Timex.to_date()
        )

      day = 2
      {:ok, _personal_affirmation} = PersonalAffirmationRepo.create(person, 1)
      {:ok, personal_affirmation} = PersonalAffirmationRepo.create(person, day)

      assert personal_affirmation.id
      assert personal_affirmation.uuid
      assert personal_affirmation.person_id == person.id
      assert personal_affirmation.day == day
      refute personal_affirmation.text
      refute personal_affirmation.approved

      assert Repo.get(PersonalAffirmation, personal_affirmation.id)
    end

    test "error with day after the sober days of person" do
      person =
        insert!(:person,
          sober_since:
            "Europe/Vienna"
            |> Timex.now()
            # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
            |> Timex.subtract(Duration.from_days(3))
            |> Timex.to_date()
        )

      {:error, changeset} = PersonalAffirmationRepo.create(person, 5)
      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :day end)
    end

    test "error with duplicate day for the same person" do
      person =
        insert!(:person,
          sober_since:
            "Europe/Vienna"
            |> Timex.now()
            # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
            |> Timex.subtract(Duration.from_days(3))
            |> Timex.to_date()
        )

      insert!(:personal_affirmation, person: person, day: 2)

      {:error, changeset} = PersonalAffirmationRepo.create(person, 2)
      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :person_id end)
    end
  end
end
