defmodule XDaysSoberWeb.DashboardTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest

  test "that developer is redirected when accessing /dashboard", %{conn: conn} do
    conn = get(conn, "/dashboard")

    assert redirected_to(conn) == "/dashboard/home"
  end

  test "that developer can view dashboard with redirected url", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/dashboard/home")

    assert html =~ "Phoenix LiveDashboard"
  end
end
