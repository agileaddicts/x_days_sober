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

  def update_text(%PersonalAffirmation{} = personal_affirmation, text) do
    personal_affirmation
    |> PersonalAffirmation.changeset(%{
      text: text
    })
    |> Repo.update()
  end

  def get_by_person_id_and_day(person_id, day) do
    Repo.get_by(PersonalAffirmation, person_id: person_id, day: day)
  end
end
