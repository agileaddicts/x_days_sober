defmodule XDaysSober.PersonRepo do
  @moduledoc false

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
