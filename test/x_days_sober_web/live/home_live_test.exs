defmodule XDaysSoberWeb.HomeLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest
  import XDaysSober.Factory

  test "visitor can access homepage", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")

    assert html =~ "X Days Sober"
  end

  test "potential user can register using unique email", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    {:ok, _view, html} =
      view
      |> form("form", person: %{email: "me@test.local"})
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "me@test.local"
    assert html =~ "Awesome! You&#39;ll receive the first email tomorrow."
  end

  test "potential user gets error message when signing up with duplicated email", %{conn: conn} do
    person = insert!(:person)

    {:ok, view, _html} = live(conn, ~p"/")

    rendered =
      view
      |> form("form", person: %{email: person.email})
      |> render_submit()

    assert rendered =~ "This email is already registered!"
  end
end
