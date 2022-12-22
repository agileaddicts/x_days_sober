defmodule XDaysSoberWeb.HomeLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user can access homepage", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "X Days Sober"
  end

  test "user can register using unique email", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, _view, html} =
      view
      |> form("form", person: %{email: "me@test.local"})
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
  end

  @tag :skip
  test "user gets error message when signing up with duplicated email", %{conn: _conn} do
  end
end
