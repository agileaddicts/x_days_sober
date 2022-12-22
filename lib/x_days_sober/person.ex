defmodule XDaysSober.Person do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Timex.Timezone

  schema "persons" do
    field :uuid, :binary_id
    field :email, :string
    field :name, :string
    field :timezone, :string
    field :sober_since, :date

    timestamps()
  end

  def changeset(person, params) do
    person
    |> cast(params, [:uuid, :email, :timezone, :sober_since])
    |> validate_required([:uuid, :email, :timezone, :sober_since])
    |> unique_constraint(:email, name: :persons_email_index)
    |> validate_timezone()
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
