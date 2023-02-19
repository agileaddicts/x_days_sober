defmodule XDaysSober.PersonRepoTest do
  use XDaysSober.DataCase, async: true

  import XDaysSober.Factory

  alias Ecto.UUID
  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSober.Repo

  describe "create/2" do
    test "correct insert with unique email and correct timezone" do
      email = "test@xdayssober.local"
      timezone = "Europe/Vienna"
      {:ok, person} = PersonRepo.create(email, timezone)

      assert person.id
      assert person.uuid
      assert person.email == email
      refute person.name
      assert person.timezone == timezone
      assert person.sober_since

      assert Repo.get(Person, person.id)
    end

    test "error with duplicated email" do
      person = insert!(:person)

      {:error, changeset} = PersonRepo.create(person.email, "Europe/Vienna")

      refute changeset.valid?
      assert %{email: ["This email is already registered!"]} = errors_on(changeset)
    end

    test "error with unique email and wrong timezone" do
      {:error, changeset} = PersonRepo.create("test@xdayssober.local", "wrong")

      refute changeset.valid?
      assert %{timezone: ["must be a valid timezone"]} = errors_on(changeset)
    end
  end

  describe "update/5" do
    test "correct update with new name, timezone and sober_since" do
      person = insert!(:person)

      {:ok, updated_person} = PersonRepo.update(person, "TestName", "Etc/UTC", "2022-01-01", true)

      assert person.name != updated_person.name
      assert person.timezone != updated_person.timezone
      assert person.unsubscribed != updated_person.unsubscribed
    end

    test "error with not existing timezone" do
      person = insert!(:person)

      {:error, changeset} =
        PersonRepo.update(person, person.name, "wrong", person.sober_since, true)

      refute changeset.valid?
      assert %{timezone: ["must be a valid timezone"]} = errors_on(changeset)
    end

    test "error with wrong date" do
      person = insert!(:person)

      {:error, changeset} = PersonRepo.update(person, person.name, person.timezone, "wrong", true)

      refute changeset.valid?
      assert %{sober_since: ["is invalid"]} = errors_on(changeset)
    end
  end

  describe "unsubscribe/1" do
    test "correct update returning unsubscribed user" do
      person = insert!(:person, unsubscribed: false)

      {:ok, updated_person} = PersonRepo.unsubscribe(person)

      assert updated_person.unsubscribed
    end

    test "correct update returning unchanged user if user is already subscribed" do
      person = insert!(:person, unsubscribed: true)

      {:ok, updated_person} = PersonRepo.unsubscribe(person)

      assert updated_person.unsubscribed
    end
  end

  describe "get_by_id/1" do
    test "correct return with existing id" do
      person = insert!(:person)

      assert PersonRepo.get_by_id(person.id)
    end

    test "correct nil return with non-existing uuid" do
      refute PersonRepo.get_by_id(100_000)
    end

    test "correct nil return with non uuid" do
      refute PersonRepo.get_by_id("wrong")
    end
  end

  describe "get_by_uuid/1" do
    test "correct return with existing uuid" do
      person = insert!(:person)

      assert PersonRepo.get_by_uuid(person.uuid)
    end

    test "correct nil return with non-existing uuid" do
      refute PersonRepo.get_by_uuid(UUID.generate())
    end

    test "correct nil return with non uuid" do
      refute PersonRepo.get_by_uuid("wrong")
    end
  end

  describe "list_subscribed/0" do
    test "correct return with no persons" do
      assert PersonRepo.list_subscribed() == []
    end

    test "correct return with subscribed persons" do
      person_1 = insert!(:person)
      insert!(:person)
      person_3 = insert!(:person, unsubscribed: true)

      subscribed_persons = PersonRepo.list_subscribed()

      assert length(subscribed_persons) == 2
      assert Enum.find(subscribed_persons, nil, fn p -> p.id == person_1.id end)
      refute Enum.find(subscribed_persons, nil, fn p -> p.id == person_3.id end)
    end
  end
end
