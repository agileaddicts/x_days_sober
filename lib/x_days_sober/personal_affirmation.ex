defmodule XDaysSober.PersonalAffirmation do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias XDaysSober.Person
  alias XDaysSober.PersonRepo

  schema "personal_affirmations" do
    field :uuid, :binary_id
    field :day, :integer
    field :text, :string
    field :approved, :boolean

    belongs_to :person, Person

    timestamps()
  end

  def changeset(personal_affirmation, params) do
    personal_affirmation
    |> cast(params, [:uuid, :person_id, :day, :approved])
    |> validate_required([:uuid, :person_id, :day, :approved])
    |> validate_day_before_sober_days()
    |> unique_constraint([:person_id, :day], name: :personal_affirmations_person_id_day_index)
  end

  defp validate_day_before_sober_days(changeset) do
    person_id = get_field(changeset, :person_id)
    day = get_field(changeset, :day)

    if person_id != nil && day != nil do
      person = PersonRepo.get_by_id(person_id)
      sober_days = Person.calculate_sober_days(person)

      if sober_days < day do
        add_error(changeset, :day, "must be within your sober days")
      else
        changeset
      end
    else
      changeset
    end
  end
end
