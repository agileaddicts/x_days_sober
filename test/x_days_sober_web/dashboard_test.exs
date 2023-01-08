defmodule XDaysSoberWeb.DashboardTest do
  use XDaysSoberWeb.ConnCase

  test "that developer is redirected when accessing /dashboard", %{conn: conn} do
    conn = get(conn, "/dashboard")

    assert redirected_to(conn) == "/dashboard/home"
  end

  test "that developer can view dashboard with redirected url", %{conn: conn} do
    conn = get(conn, "/dashboard/home")

    assert html_response(conn, 200) =~ "Phoenix LiveDashboard"
  end
end
