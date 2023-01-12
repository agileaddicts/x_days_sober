defmodule XDaysSober.Repo.Migrations.AlterPersonAddUnsubscribed do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :unsubscribed, :boolean, default: false, null: false
    end
  end
end
