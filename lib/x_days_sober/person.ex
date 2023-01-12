defmodule XDaysSober.Person do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Timex.Timezone
  alias XDaysSober.Person
  alias XDaysSober.PersonalAffirmation

  schema "persons" do
    field :uuid, :binary_id
    field :email, :string
    field :name, :string
    field :timezone, :string
    field :sober_since, :date
    field :unsubscribed, :boolean, default: false

    has_many :personal_affirmations, PersonalAffirmation

    timestamps()
  end

  def changeset(person, params) do
    person
    |> cast(params, [:uuid, :email, :name, :timezone, :sober_since, :unsubscribed])
    |> validate_required([:uuid, :email, :timezone, :sober_since])
    |> unique_constraint(:email,
      name: :persons_email_index,
      message: "This email is already registered!"
    )
    |> validate_timezone()
  end

  def calculate_sober_days(%Person{} = person) do
    person.timezone
    |> Timex.now()
    |> Timex.to_date()
    |> Timex.diff(person.sober_since, :days)
  end

  defp validate_timezone(changeset) do
    timezone = get_field(changeset, :timezone)

    if timezone != nil && Timezone.exists?(timezone) do
      changeset
    else
      add_error(changeset, :timezone, "must be a valid timezone")
    end
  end
end
