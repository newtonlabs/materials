defmodule Materials.Repo.Migrations.CreateManyToMany do
  use Ecto.Migration

  def change do
    create table(:dishes_ingredients, primary_key: false) do
      add(:dish_id, references(:dishes))
      add(:ingredient_id, references(:ingredients))
    end

    create table(:meals_dishes, primary_key: false) do
      add(:meal_id, references(:meals))
      add(:dish_id, references(:dishes))
    end
  end
end
