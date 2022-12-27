defmodule XDaysSober.Repo.Migrations.CreatePersonalAffirmations do
  use Ecto.Migration

  def change do
    create table(:personal_affirmations) do
      add :uuid, :uuid, null: false
      add :person_id, references(:persons), null: false
      add :day, :integer, null: false
      add :text, :text, null: true
      add :approved, :boolean, null: false

      timestamps()
    end

    create(
      unique_index(:personal_affirmations, [:person_id, :day],
        name: :personal_affirmations_person_id_day_index
      )
    )
  end
end
