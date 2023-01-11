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
      person = insert_person_with_days_sober(%{}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_email_sent(DailyEmail.generate(person, 1))
    end

    test "sending no email to person which is unsubscribed" do
      insert_person_with_days_sober(%{unsubscribed: true}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end
  end
end
