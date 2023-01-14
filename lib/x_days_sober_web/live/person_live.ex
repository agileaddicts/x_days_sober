defmodule XDaysSoberWeb.PersonLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.HomeLive
  alias XDaysSoberWeb.PersonLive
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
      |> maybe_unsubscribe(person, params)
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
    new_name = Map.get(params, "name", "")
    new_timezone = Map.get(params, "timezone", "")
    new_unsubscribed = Map.get(params, "unsubscribed", "1") == "1"

    case PersonRepo.update(socket.assigns.person, new_name, new_timezone, new_unsubscribed) do
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

  defp maybe_unsubscribe(socket, person, %{"unsubscribe" => _unsubscribe}) do
    {:ok, person} = PersonRepo.unsubscribe(person)

    socket
    |> assign(person: person)
    |> put_flash(:warning, "You won't receive any emails from us anymore!")
    |> push_redirect(
      to:
        Helpers.live_path(
          socket,
          PersonLive,
          person.uuid
        )
    )
  end

  defp maybe_unsubscribe(socket, _person, _params), do: socket

  defp sober_days(%Person{} = person) do
    case Person.calculate_sober_days(person) do
      1 -> "1 day"
      days -> "#{days} days"
    end
  end
end
