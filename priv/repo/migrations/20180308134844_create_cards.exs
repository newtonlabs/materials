defmodule Materials.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add(:name, :string)
      add(:body, :string)
      add(:section_id, references(:sections, on_delete: :delete_all))

      timestamps()
    end

    # Yeah fix this
    create(unique_index(:cards, [:name]))
  end
end
