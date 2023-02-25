defmodule XDaysSoberWeb.PersonalAffirmationLiveTest do
  use XDaysSoberWeb.ConnCase

  import Phoenix.LiveViewTest
  import XDaysSober.Factory

  alias Ecto.UUID
  alias XDaysSober.PersonalAffirmationRepo

  test "user can access personal affirmation page", %{conn: conn} do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} = live(conn, ~p"/pa/#{person.uuid}/1")

    assert html =~ "day 1"
  end

  test "visitor is redirected to homepage when person does not exist", %{conn: conn} do
    {:ok, _view, html} =
      conn
      |> live(~p"/pa/#{UUID.generate()}/1")
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
    refute html =~ "day 1"
  end

  test "visitor is redirected to person detail page when day is higher than sober days", %{
    conn: conn
  } do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} =
      conn
      |> live(~p"/pa/#{person.uuid}/5")
      |> follow_redirect(conn)

    assert html =~ person.email
  end

  test "visitor is redirected to person detail page when day is invalid", %{
    conn: conn
  } do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, _view, html} =
      conn
      |> live(~p"/pa/#{person.uuid}/abc")
      |> follow_redirect(conn)

    assert html =~ "X Days Sober"
    refute html =~ person.email
  end

  test "user can change text on personal affirmation page", %{conn: conn} do
    person = insert_person_with_days_sober(%{}, 3)

    {:ok, view, _html} = live(conn, ~p"/pa/#{person.uuid}/1")

    html =
      view
      |> form("form", personal_affirmation: %{text: "Lorem ipsum dolor!"})
      |> render_submit()

    assert html =~ "Lorem ipsum dolor!"
    assert html =~ "Saved!"

    personal_affirmation = PersonalAffirmationRepo.get_by_person_id_and_day(person.id, 1)

    assert personal_affirmation.text == "Lorem ipsum dolor!"
  end
end
