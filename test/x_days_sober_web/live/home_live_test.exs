defmodule XDaysSoberWeb.HomeLiveTest do
  use XDaysSoberWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "X Days Sober"
  end
end
