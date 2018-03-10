require IEx

defmodule Materials.Meals do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Meal}

  def create_meal(attrs \\ %{}) do
    %Meal{}
    |> Meal.changeset(attrs)
    |> Repo.insert()
  end

  def update_meal(%Meal{} = meal, attrs) do
    meal
    |> Meal.changeset(attrs)
    |> Repo.update()
  end

  def get_meal!(id),
    do:
      Repo.get!(Meal, id)
      |> Repo.preload(dishes: :ingredients)

  def list_meals do
    Repo.all(Meal) |> Materials.Repo.preload(dishes: :ingredients)
  end

  def shopping_list(meals) do
    meals
    |> Enum.flat_map(fn meal -> Enum.flat_map(meal.dishes, fn dish -> dish.ingredients end) end)
    |> Enum.group_by(fn i -> task_name(i) end, fn i -> task_name(i) end)
    |> Enum.map(fn {key, value} -> task_quantity(key, length(value)) end)
  end

  def task_name(ingredient) do
    "#{ingredient.location} - #{ingredient.name}"
  end

  def task_quantity(task, quantity) when quantity > 1, do: "#{task} (#{quantity})"
  def task_quantity(task, _), do: "#{task}"
end
