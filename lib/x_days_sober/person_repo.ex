defmodule XDaysSober.PersonRepo do
  @moduledoc false

  import Ecto.Query

  alias Ecto.UUID
  alias Timex.Timezone
  alias XDaysSober.Person
  alias XDaysSober.Repo

  def create(email, timezone) do
    %Person{}
    |> Person.changeset(%{
      uuid: UUID.generate(),
      email: email,
      timezone: timezone,
      sober_since: generate_today_date(timezone)
    })
    |> Repo.insert()
  end

  def update(person, name, timezone, sober_since, unsubscribed) do
    person
    |> Person.changeset(%{
      name: name,
      timezone: timezone,
      sober_since: sober_since,
      unsubscribed: unsubscribed
    })
    |> Repo.update()
  end

  def unsubscribe(person) do
    person
    |> Person.changeset(%{
      unsubscribed: true
    })
    |> Repo.update()
  end

  def get_by_id(id) do
    Repo.get(Person, id)
  rescue
    Ecto.Query.CastError -> nil
  end

  def get_by_uuid(uuid) do
    Repo.get_by(Person, uuid: uuid)
  rescue
    Ecto.Query.CastError -> nil
  end

  def list_subscribed do
    query =
      from p in Person,
        where: p.unsubscribed == false

    Repo.all(query)
  end

  defp generate_today_date(timezone) do
    if Timezone.exists?(timezone) do
      timezone
      |> Timex.now()
      |> Timex.to_date()
    else
      Timex.to_date(Timex.now())
    end
  end
end
