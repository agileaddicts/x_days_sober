defmodule XDaysSoberWeb.PersonLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.Router.Helpers
  alias XDaysSoberWeb.HomeLive

  def mount(params, _session, socket) do
    with uuid when is_binary(uuid) <- Map.get(params, "uuid"),
         %Person{} = person <- PersonRepo.get_by_uuid(uuid) do
      socket
      |> assign(person: person)
      |> ok()
    else
      nil ->
        {:ok,
         push_redirect(socket,
           to:
             Helpers.live_path(
               socket,
               HomeLive
             )
         )}
    end
  end

  defp sober_days(%Person{} = person) do
    case Person.calculate_sober_days(person) do
      1 -> "1 day"
      days -> "#{days} days"
    end
  end
end
