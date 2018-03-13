defmodule Materials.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add(:name, :string)
      add(:location, :string)
      add(:frequency, :string)
      add(:section_id, references(:sections, on_delete: :delete_all))
      add(:table_id, references(:tables, on_delete: :delete_all))

      timestamps()
    end

    create(unique_index(:ingredients, [:name]))
  end
end
