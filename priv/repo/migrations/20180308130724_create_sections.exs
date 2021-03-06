defmodule Materials.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add(:name, :string)
      add(:box_id, references(:boxes, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:sections, [:name]))
  end
end
