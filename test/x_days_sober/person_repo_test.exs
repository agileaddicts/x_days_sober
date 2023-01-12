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

  describe "update/2" do
    test "correct update with new name and timezone" do
      person = insert!(:person)

      {:ok, updated_person} = PersonRepo.update(person, "TestName", "Europe/Vienna")

      assert person.name != updated_person.name
    end

    test "error with not existing timezone" do
      person = insert!(:person)

      {:error, changeset} = PersonRepo.update(person, "TestName", "wrong")

      refute changeset.valid?
      assert %{timezone: ["must be a valid timezone"]} = errors_on(changeset)
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
end
