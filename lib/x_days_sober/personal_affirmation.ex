defmodule XDaysSober.PersonalAffirmation do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias XDaysSober.Person

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
    |> unique_constraint([:person_id, :day], name: :personal_affirmations_person_id_day_index)
  end
end
