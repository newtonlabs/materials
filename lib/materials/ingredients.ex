defmodule Materials.Ingredients do
  import Ecto.Query, warn: false
  alias Materials.Repo
  alias Materials.Ingredient

  def list_ingredients do
    Repo.all(Ingredient)
  end

  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  # TODO: Transaction Please
  def upsert_ingredient_from_components(components) do
    components
    |> Ingredient.parse_components()
    |> get_ingredient_by_component
    |> upsert_ingredient()
  end

  def get_ingredient_by_component({name, location}) do
    ingredient = List.first(Repo.all(from(i in Ingredient, where: i.name == ^name)))
    {name, location, ingredient}
  end

  def upsert_ingredient({name, location, nil}) do
    create_ingredient(%{name: name, location: location})
  end

  def upsert_ingredient({name, location, %Ingredient{} = ingredient}) do
    update_ingredient(ingredient, %{name: name, location: location})
  end

  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end
end
