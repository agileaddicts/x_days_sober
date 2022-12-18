defmodule XDaysSober.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :uuid, :uuid, null: false
      add :email, :string, null: false
      add :name, :string, null: true
      add :timezone, :string, null: false
      add :sober_since, :date, null: false

      timestamps()
    end

    create(unique_index(:persons, :uuid, name: :persons_uuid_index))
    create(unique_index(:persons, :email, name: :persons_email_index))
  end
end
