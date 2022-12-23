defmodule XDaysSoberWeb.PersonLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest
  import XDaysSober.Factory
  alias XDaysSoberWeb.Router.Helpers
  alias XDaysSoberWeb.PersonLive

  test "user can access his personal page", %{conn: conn} do
    person = insert!(:person)

    {:ok, _view, html} = live(conn, person_path(conn, person.uuid))

    assert html =~ person.email
  end

  test "visitor is redirected when uuid does not exist", %{conn: conn} do
    {:ok, _view, html} =
      live(conn, person_path(conn, Ecto.UUID.generate())) |> follow_redirect(conn)

    assert html =~ "X Days Sober"
  end

  defp person_path(conn, uuid) do
    Helpers.live_path(
      conn,
      PersonLive,
      uuid
    )
  end
end
