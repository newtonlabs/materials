defmodule Materials.Repo.Migrations.CreateManyToMany do
  use Ecto.Migration

  def change do
    create table(:dishes_ingredients, primary_key: false) do
      add(:dish_id, references(:dishes, on_delete: :delete_all))
      add(:ingredient_id, references(:ingredients, on_delete: :delete_all))
    end

    create table(:meals_dishes, primary_key: false) do
      add(:meal_id, references(:meals, on_delete: :delete_all))
      add(:dish_id, references(:dishes, on_delete: :delete_all))
    end
  end
end
