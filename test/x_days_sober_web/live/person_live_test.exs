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

  test "user can edit and save with same values", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, person_path(conn, person.uuid))

    view
    |> element("button", "Edit")
    |> render_click()

    html =
      view
      |> form("form")
      |> render_submit()

    assert html =~ "Saved!"
    assert html =~ person.name
    assert html =~ person.timezone
  end

  test "user can edit and save with new name", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, person_path(conn, person.uuid))

    view
    |> element("button", "Edit")
    |> render_click()

    html =
      view
      |> form("form", name: "Test Name")
      |> render_submit()

    assert html =~ "Saved!"
    assert html =~ "Test Name"
    refute html =~ person.name
    assert html =~ person.timezone
  end

  test "user can edit and save with new tiemzone", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, person_path(conn, person.uuid))

    view
    |> element("button", "Edit")
    |> render_click()

    html =
      view
      |> form("form", timezone: "America/New_York")
      |> render_submit()

    assert html =~ "Saved!"
    assert html =~ person.name
    assert html =~ "America/New_York"
    refute html =~ person.timezone
  end

  defp person_path(conn, uuid) do
    Helpers.live_path(
      conn,
      PersonLive,
      uuid
    )
  end
end
