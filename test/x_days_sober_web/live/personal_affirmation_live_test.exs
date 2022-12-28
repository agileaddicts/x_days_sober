defmodule XDaysSoberWeb.PersonalAffirmationLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest
  import XDaysSober.Factory

  alias Ecto.UUID
  alias XDaysSoberWeb.PersonalAffirmationLive
  alias XDaysSoberWeb.Router.Helpers

  test "user can access personal affirmation page", %{conn: conn} do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} = live(conn, personal_affirmation_path(conn, person.uuid, 1))

    assert html =~ "day 1"
  end

  test "visitor is redirected to homepage when person does not exist", %{conn: conn} do
    {:ok, _view, html} =
      conn
      |> live(personal_affirmation_path(conn, UUID.generate(), 1))
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
    refute html =~ "day 1"
  end

  test "visitor is redirected to person detail page when day is higher than sober days", %{
    conn: conn
  } do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} =
      conn
      |> live(personal_affirmation_path(conn, person.uuid, 5))
      |> follow_redirect(conn)

    assert html =~ person.email
  end

  test "visitor is redirected to person detail page when day is invalid", %{
    conn: conn
  } do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} =
      conn
      |> live(personal_affirmation_path(conn, person.uuid, "abc"))
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
    refute html =~ person.email
  end

  defp personal_affirmation_path(conn, person_uuid, day) do
    Helpers.live_path(
      conn,
      PersonalAffirmationLive,
      person_uuid,
      day
    )
  end
end