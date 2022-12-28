defmodule XDaysSober.PersonalAffirmationRepoTest do
  use XDaysSober.DataCase, async: true

  import XDaysSober.Factory

  alias XDaysSober.PersonalAffirmation
  alias XDaysSober.PersonalAffirmationRepo
  alias XDaysSober.Repo

  describe "create/2" do
    test "correct insert with unique person and day" do
      person = insert_person_with_days_sober(%{}, 3)

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
      person = insert_person_with_days_sober(%{}, 3)

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
      person = insert_person_with_days_sober(%{}, 3)

      {:error, changeset} = PersonalAffirmationRepo.create(person, 5)
      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :day end)
    end

    test "error with duplicate day for the same person" do
      person = insert_person_with_days_sober(%{}, 3)

      insert!(:personal_affirmation, person: person, day: 2)

      {:error, changeset} = PersonalAffirmationRepo.create(person, 2)
      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :person_id end)
    end
  end

  describe "get_by_person_id_and_day/2" do
    test "returns existing entry for person and day" do
      person = insert_person_with_days_sober(%{}, 5)
      insert!(:personal_affirmation, %{person: person, day: 3})

      assert PersonalAffirmationRepo.get_by_person_id_and_day(person.id, 3)
    end

    test "returns nil for exisitng person and non-existing day" do
      person = insert_person_with_days_sober(%{}, 5)

      refute PersonalAffirmationRepo.get_by_person_id_and_day(person.id, 3)
    end

    test "returns nil for non-existing person and day" do
      refute PersonalAffirmationRepo.get_by_person_id_and_day(100_000, 3)
    end
  end
end
