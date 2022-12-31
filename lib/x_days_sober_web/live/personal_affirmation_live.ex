defmodule XDaysSoberWeb.PersonalAffirmationLive do
  use XDaysSoberWeb, :live_view

  alias XDaysSober.Person
  alias XDaysSober.PersonalAffirmation
  alias XDaysSober.PersonalAffirmationRepo
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.HomeLive
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  def mount(params, _session, socket) do
    with %Person{} = person <- get_person_from_params(params),
         day when is_integer(day) <- get_day_from_params(params) do
      case get_or_create(person, day) do
        %PersonalAffirmation{} = personal_affirmation ->
          socket
          |> assign(person: person, personal_affirmation: personal_affirmation)
          |> ok()

        _else ->
          socket
          |> push_redirect(
            to:
              Helpers.live_path(
                socket,
                PersonLive,
                person.uuid
              )
          )
          |> ok()
      end
    else
      _else ->
        socket
        |> push_redirect(
          to:
            Helpers.live_path(
              socket,
              HomeLive
            )
        )
        |> ok()
    end
  end

  def handle_event("save", %{"personal_affirmation" => params}, socket) do
    case PersonalAffirmationRepo.update_text(
           socket.assigns.personal_affirmation,
           params["text"]
         ) do
      {:ok, personal_affirmation} ->
        socket
        |> assign(personal_affirmation: personal_affirmation)
        |> put_flash(:success, "Saved!")
        |> noreply()

      {:error, _changeset} ->
        socket
        |> put_flash(:error, "Could not save affirmation for today")
        |> noreply()
    end
  end

  defp get_person_from_params(%{"person_uuid" => person_uuid}) do
    PersonRepo.get_by_uuid(person_uuid)
  end

  defp get_person_from_params(_params), do: nil

  defp get_day_from_params(%{"day" => day}) do
    case Integer.parse(day) do
      {day, _rem} -> day
      _else -> nil
    end
  end

  defp get_day_from_params(_params), do: nil

  defp get_or_create(person, day) do
    case PersonalAffirmationRepo.get_by_person_id_and_day(person.id, day) do
      nil ->
        case PersonalAffirmationRepo.create(person, day) do
          {:ok, personal_affirmation} -> personal_affirmation
          {:error, _changeset} -> nil
        end

      personal_affirmation ->
        personal_affirmation
    end
  end
end
