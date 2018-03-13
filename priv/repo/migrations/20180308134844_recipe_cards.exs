defmodule Materials.Repo.Migrations.CreateRecipeCards do
  use Ecto.Migration

  def change do
    create table(:recipe_cards) do
      add(:name, :string)
      add(:body, :string)

      timestamps()
    end

    create(unique_index(:recipe_cards, [:name]))
  end
end
