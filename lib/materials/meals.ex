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
      |> Materials.Repo.preload(dishes: :ingredients)

  def list_meals do
    Repo.all(Meal) |> Materials.Repo.preload(dishes: :ingredients)
  end
end
