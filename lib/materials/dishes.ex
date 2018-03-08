defmodule Materials.Dishes do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Ingredient, Dish}

  def create_dish(attrs \\ %{}) do
    %Dish{}
    |> Dish.changeset(attrs)
    |> Repo.insert()
  end

  def update_dish(%Dish{} = dish, attrs) do
    dish
    |> Dish.changeset(attrs)
    |> Repo.update()
  end

  def get_dish!(id), do: Repo.get!(Dish, id) |> Materials.Repo.preload([:ingredients])
end
