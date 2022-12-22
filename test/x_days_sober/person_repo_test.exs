defmodule XDaysSober.PersonRepoTest do
  use XDaysSober.DataCase, async: true

  alias Ecto.UUID
  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSober.Repo

  describe "create/1" do
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

    @tag :skip
    test "error with duplicated email" do
    end

    test "error with unique email and wrong timezone" do
      {:error, changeset} = PersonRepo.create("test@xdayssober.local", "wrong")

      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :timezone end)
    end
  end

  describe "get_by_uuid/1" do
    @tag :skip
    test "correct return with existing uuid" do
    end

    test "correct error return with non-existing uuid" do
      refute PersonRepo.get_by_uuid(UUID.generate())
    end
  end
end
