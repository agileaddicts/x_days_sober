defmodule XDaysSober.PersonalAffirmationRepo do
  @moduledoc false

  alias Ecto.UUID
  alias XDaysSober.Person
  alias XDaysSober.PersonalAffirmation
  alias XDaysSober.Repo

  def create(%Person{} = person, day) do
    %PersonalAffirmation{}
    |> PersonalAffirmation.changeset(%{
      uuid: UUID.generate(),
      person_id: person.id,
      day: day,
      approved: false
    })
    |> Repo.insert()
  end
end
