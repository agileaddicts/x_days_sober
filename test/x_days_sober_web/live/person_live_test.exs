defmodule XDaysSoberWeb.PersonLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.HTML
  import Phoenix.LiveViewTest
  import XDaysSober.Factory

  alias Ecto.UUID
  alias XDaysSober.PersonRepo
  alias XDaysSoberWeb.PersonLive
  alias XDaysSoberWeb.Router.Helpers

  test "user can access person detail page", %{conn: conn} do
    person = insert!(:person)

    {:ok, _view, html} = live(conn, person_path(conn, person.uuid))

    assert html =~ person.email
    assert html =~ "(0 days)"
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

  test "user can unsubscribe via link", %{conn: conn} do
    person = insert!(:person)

    {:ok, _view, html} = live(conn, person_path(conn, person.uuid, unsubscribe: 1))

    assert html =~ "You won&#39;t receive any emails from us anymore!"

    person_from_db = PersonRepo.get_by_id(person.id)

    assert person_from_db.unsubscribed
  end

  test "user can see correct indication of 1 day sober", %{conn: conn} do
    person = insert_person_with_days_sober(%{}, 1)

    {:ok, _view, html} = live(conn, person_path(conn, person.uuid))

    assert html =~ person.email
    assert html =~ "(1 day)"
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
    assert html =~ person.name |> html_escape() |> safe_to_string()
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
    refute html =~ person.name |> html_escape() |> safe_to_string()
  end

  test "user can remove his name", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, person_path(conn, person.uuid))

    view
    |> element("button", "Edit")
    |> render_click()

    html =
      view
      |> form("form", name: nil)
      |> render_submit()

    assert html =~ "Saved!"
    refute html =~ person.name |> html_escape() |> safe_to_string()
  end

  test "user can edit and save with new timezone", %{conn: conn} do
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
    assert html =~ "America/New_York"
    refute html =~ person.timezone
  end

  # Has to be implemented
  @tag :skip
  test "user gets error if sending invalid timezone" do
  end

  defp person_path(conn, uuid, params \\ []) do
    Helpers.live_path(
      conn,
      PersonLive,
      uuid,
      params
    )
  end
end
