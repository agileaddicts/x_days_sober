defmodule XDaysSober.Factory do
  @moduledoc false

  alias Ecto.UUID
  alias Faker.Internet
  alias XDaysSober.Person
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

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
