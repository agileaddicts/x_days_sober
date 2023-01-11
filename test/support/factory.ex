defmodule XDaysSober.Factory do
  @moduledoc false

  alias Ecto.UUID
  alias Faker.Internet
  alias Faker.Lorem
  alias Timex.Duration
  alias XDaysSober.Person
  alias XDaysSober.PersonalAffirmation
  alias XDaysSober.Repo

  # Factories

  def build(:person) do
    %Person{
      uuid: UUID.generate(),
      email: Internet.email(),
      name: Faker.Person.name(),
      timezone: "Europe/Vienna",
      sober_since: Timex.to_date(Timex.now()),
      unsubscribed: false
    }
  end

  def build(:personal_affirmation) do
    %PersonalAffirmation{
      uuid: UUID.generate(),
      person: build(:person),
      day: 1,
      text: Lorem.sentence(5..10),
      approved: false
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def build_person_with_days_sober(attributes, days_sober) do
    timezone = Map.get(attributes, :timezone, "Europe/Vienna")

    sober_since =
      timezone
      |> Timex.now()
      # credo:disable-for-next-line Credo.Check.Readability.NestedFunctionCalls
      |> Timex.subtract(Duration.from_days(days_sober))
      |> Timex.to_date()

    build(:person, Map.put(attributes, :sober_since, sober_since))
  end

  def insert_person_with_days_sober(attributes, days_sober) do
    attributes
    |> build_person_with_days_sober(days_sober)
    |> Repo.insert!()
  end
end
