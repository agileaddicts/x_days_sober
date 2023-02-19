defmodule XDaysSober.EmailWorkerTest do
  use XDaysSober.DataCase, async: true
  use Oban.Testing, repo: XDaysSober.Repo

  import Swoosh.TestAssertions
  import XDaysSober.Factory

  alias XDaysSober.DailyEmail
  alias XDaysSober.EmailWorker

  describe "perform/1" do
    test "sending no mails with no persons in database" do
      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end

    test "sending no mail to person signed up today" do
      insert!(:person)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end

    test "sending one email to person" do
      tz = get_timezone_with_hour(5)
      person = insert_person_with_days_sober(%{timezone: tz}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_email_sent(DailyEmail.generate(person, %{days: 1, weeks: -1, months: -1, years: -1}))
    end

    test "sending no email to person with timezone that is currently not 5" do
      tz = get_timezone_with_hour(10)
      insert_person_with_days_sober(%{timezone: tz}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end

    test "sending no email to person which is unsubscribed" do
      insert_person_with_days_sober(%{unsubscribed: true}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end
  end

  defp get_timezone_with_hour(hour) do
    Tzdata.canonical_zone_list()
    |> Enum.map(fn timezone ->
      hours =
        timezone
        |> Timex.now()
        |> Timex.format("%H", :strftime)
        |> then(fn {:ok, timezone_hour_string} -> String.to_integer(timezone_hour_string) end)

      {timezone, hours}
    end)
    |> Enum.find(nil, fn {_timezone, hours} -> hours == hour end)
    |> then(fn {timezone, _hours} -> timezone end)
  end
end
