defmodule XDaysSober.EmailWorkerTest do
  use XDaysSober.DataCase, async: true
  use Oban.Testing, repo: XDaysSober.Repo

  import Swoosh.TestAssertions
  import XDaysSober.Factory

  alias XDaysSober.EmailWorker

  describe "perform/1" do
    test "executes job but does not send any mails with no persons in database" do
      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end

    test "executes job but does not send any mails with person signed up today" do
      insert!(:person)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_no_email_sent()
    end

    test "executes job and does send one email to person" do
      insert_person_with_days_sober(%{}, 1)

      assert perform_job(EmailWorker, %{}) == :ok
      assert_email_sent()
    end
  end
end
