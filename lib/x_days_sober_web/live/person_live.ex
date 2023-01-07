defmodule XDaysSoberWeb.PersonLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.HomeLive
  alias XDaysSoberWeb.Router.Helpers

  def mount(params, _session, socket) do
    with uuid when is_binary(uuid) <- Map.get(params, "uuid"),
         %Person{} = person <- PersonRepo.get_by_uuid(uuid) do
      socket
      |> assign(
        person: person,
        edit_view: false,
        timezones: Tzdata.canonical_zone_list()
      )
      |> ok()
    else
      _else ->
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

  def handle_event("toggle_edit", _params, socket) do
    socket
    |> assign(edit_view: !socket.assigns.edit_view)
    |> noreply()
  end

  def handle_event("save", params, socket) do
    case PersonRepo.update(socket.assigns.person, params["name"], params["timezone"]) do
      {:ok, person} ->
        socket
        |> put_flash(:success, "Saved!")
        |> assign(person: person, edit_view: false)
        |> noreply()

      {:error, _changeset} ->
        socket
        |> put_flash(:error, "Error when saving!")
        |> noreply()
    end
  end

  defp sober_days(%Person{} = person) do
    case Person.calculate_sober_days(person) do
      1 -> "1 day"
      days -> "#{days} days"
    end
  end
end
