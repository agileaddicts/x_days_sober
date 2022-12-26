defmodule XDaysSober.Factory do
  @moduledoc false

  alias Ecto.UUID
  alias Faker.Internet
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
      sober_since: Timex.to_date(Timex.now())
    }
  end

  def build(:personal_affirmation) do
    %PersonalAffirmation{
      uuid: UUID.generate(),
      person: build(:person),
      day: 1,
      text: Faker.Lorem.sentence(5..10),
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
end
