defmodule XDaysSoberWeb.PersonLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.Router.Helpers
  alias XDaysSoberWeb.HomeLive

  def mount(params, _session, socket) do
    with uuid when is_binary(uuid) <- Map.get(params, "uuid"),
         %XDaysSober.Person{} = person <- PersonRepo.get_by_uuid(uuid) do
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
end
