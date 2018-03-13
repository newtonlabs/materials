defmodule Materials.Dishes do
  import Ecto.Query, warn: false
  alias Materials.{Repo, RecipeCard}

  def create_recipe_card(attrs \\ %{}) do
    %RecipeCard{}
    |> RecipeCard.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe_card(%RecipeCard{} = recipe_card, attrs) do
    recipe_card
    |> RecipeCard.changeset(attrs)
    |> Repo.update()
  end

  def list_recipe_card() do
    Repo.all(RecipeCard) |> Repo.preload(:ingredients)
  end

  def get_recipe_card!(id), do: Repo.get!(RecipeCard, id) |> Repo.preload([:ingredients])
end
