defmodule XDaysSoberWeb.HomeLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.Person
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  def mount(_params, _session, socket) do
    socket = assign(socket, changeset: Person.changeset(%Person{}, %{}))
    {:ok, socket}
  end

  def handle_event("save", %{"person" => params}, socket) do
    validated_timezone =
      if Tzdata.canonical_zone?(params["timezone"]), do: params["timezone"], else: "Etc/UTC"

    case PersonRepo.create(params["email"], validated_timezone) do
      {:ok, person} ->
        socket = put_flash(socket, :success, "Awesome! You'll receive the first email tomorrow.")

        {:noreply,
         push_redirect(socket,
           to:
             Helpers.live_path(
               socket,
               PersonLive,
               person.uuid
             )
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
