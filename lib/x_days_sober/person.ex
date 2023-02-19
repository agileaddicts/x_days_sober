defmodule XDaysSober.Person do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

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
    %{
      days: calculate_days(person),
      weeks: calculate_weeks(person),
      months: calculate_months(person),
      years: calculate_years(person)
    }
  end

  defp validate_timezone(changeset) do
    timezone = get_field(changeset, :timezone)

    if timezone != nil && Tzdata.canonical_zone?(timezone) do
      changeset
    else
      add_error(changeset, :timezone, "must be a valid timezone")
    end
  end

  defp calculate_days(person) do
    person.timezone
    |> Timex.now()
    |> Timex.to_date()
    |> Timex.diff(person.sober_since, :days)
  end

  defp calculate_weeks(person) do
    week_different = Timex.diff(Timex.now(), person.sober_since, :week)

    full_week? =
      person.sober_since |> Timex.shift(weeks: week_different) |> Timex.to_date() ==
        Timex.to_date(Timex.now())

    if full_week? do
      week_different
    else
      -1
    end
  end

  defp calculate_months(person) do
    month_different = Timex.diff(Timex.now(), person.sober_since, :month)

    full_month? =
      person.sober_since |> Timex.shift(months: month_different) |> Timex.to_date() ==
        Timex.to_date(Timex.now())

    if full_month? do
      month_different
    else
      -1
    end
  end

  defp calculate_years(person) do
    year_different = Timex.diff(Timex.now(), person.sober_since, :year)

    full_year? =
      person.sober_since |> Timex.shift(years: year_different) |> Timex.to_date() ==
        Timex.to_date(Timex.now())

    if full_year? do
      year_different
    else
      -1
    end
  end
end
