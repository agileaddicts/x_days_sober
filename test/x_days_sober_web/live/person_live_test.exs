defmodule XDaysSoberWeb.PersonLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest
  import XDaysSober.Factory

  alias Ecto.UUID
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  test "user can access person detail page", %{conn: conn} do
    person = insert!(:person)

    {:ok, _view, html} = live(conn, person_path(conn, person.uuid))

    assert html =~ person.email
  end

  test "visitor is redirected when uuid does not exist", %{conn: conn} do
    {:ok, _view, html} =
      conn
      |> live(person_path(conn, UUID.generate()))
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
  end

  test "visitor is redirected when uuid is not a real uuid", %{conn: conn} do
    {:ok, _view, html} =
      conn
      |> live(person_path(conn, "wrong"))
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
  end

  test "user can edit name", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, person_path(conn, person.uuid))

    view
    |> element("button", "Edit")
    |> render_click()

    html =
      view
      |> form("form", name: "TestUser")
      |> render_submit()

    assert html =~ "Saved!"
    assert html =~ "TestUser"
  end

  defp person_path(conn, uuid) do
    Helpers.live_path(
      conn,
      PersonLive,
      uuid
    )
  end
end
