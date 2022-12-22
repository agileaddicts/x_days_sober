defmodule XDaysSoberWeb.PersonLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest

  @tag :skip
  test "user can access his personal page", %{conn: conn} do
  end

  test "visitor is redirected when uuid does not exist", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/p/#{Ecto.UUID.generate()}") |> follow_redirect(conn)

    assert html =~ "X Days Sober"
  end
end
