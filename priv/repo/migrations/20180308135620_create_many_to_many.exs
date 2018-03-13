defmodule Materials.Repo.Migrations.CreateManyToMany do
  use Ecto.Migration

  def change do
    create table(:cards_ingredients, primary_key: false) do
      add(:card_id, references(:cards, on_delete: :delete_all))
      add(:ingredient_id, references(:ingredients, on_delete: :delete_all))
    end
  end
end
