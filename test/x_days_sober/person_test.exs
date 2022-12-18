defmodule XDaysSober.PersonTest do
  use XDaysSober.DataCase, async: true

  alias XDaysSober.Person
  alias XDaysSober.Repo

  describe "create/1" do
    test "correct insert with unique email and correct timezone" do
      {:ok, person} = Person.create("test@xdayssober.local", "Europe/Vienna")

      assert person.id
      assert person.uuid

      assert Repo.get(Person, person.id)
    end

    @tag :skip
    test "error with duplicated email" do
    end

    test "correct insert with unique email and wrong timezone" do
      {:error, changeset} = Person.create("test@xdayssober.local", "wrong")

      refute changeset.valid?
      assert length(changeset.errors) == 1
      assert Enum.any?(changeset.errors, fn {field, _error} -> field == :timezone end)
    end
  end
end
