require IEx

defmodule Materials.Boxes do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Box}

  def create_box(attrs \\ %{}) do
    %Box{}
    |> Box.changeset(attrs)
    |> Repo.insert()
  end

  #
  # def update_meal(%Meal{} = meal, attrs) do
  #   meal
  #   |> Meal.changeset(attrs)
  #   |> Repo.update()
  # end
  #
  # def get_meal!(id),
  #   do:
  #     Repo.get!(Meal, id)
  #     |> Repo.preload(dishes: :ingredients)
  #
  # def list_meals do
  # Repo.all(Meal) |> Materials.Repo.preload(dishes: :ingredients)
  # end
  #
  # # TODO: this really needs some cleanup work
  # def shopping_list(meals) do
  #   meals
  #   |> Enum.flat_map(fn meal -> Enum.flat_map(meal.dishes, fn dish -> dish.ingredients end) end)
  #   |> Enum.group_by(&task_name/1, &task_name/1)
  #   |> Enum.map(fn {{id, name}, value} ->
  #     %{id: id, name: task_quantity(name, length(value))}
  #   end)
  # end
  #
  # def task_name(ingredient) do
  #   {ingredient.id, "#{ingredient.location} - #{ingredient.name}"}
  # end
  #
  # def task_quantity(task, quantity) when quantity > 1, do: "#{task} (#{quantity})"
  # def task_quantity(task, _), do: "#{task}"
end