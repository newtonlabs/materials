require IEx

defmodule IngredientsTest do
  use Materials.DataCase
  alias Materials.{Ingredients, Ingredient}

  describe "ingredients" do
    @valid_attrs %{name: "some name", location: "some location", frequency: "often"}
    @update_attrs %{name: "some updated name", location: "some updated location"}
    @invalid_attrs %{name: nil, frequency: "whenever"}

    def ingredient_fixture(attrs \\ %{}) do
      {:ok, ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ingredients.create_ingredient()

      ingredient
    end

    test "list_ingredients/0 returns all clients" do
      ingredient = ingredient_fixture()
      assert Ingredients.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Ingredients.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{} = ingredient} = Ingredients.create_ingredient(@valid_attrs)
      assert ingredient.name == "some name"
      assert ingredient.location == "some location"
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, ingredient} = Ingredients.update_ingredient(ingredient, @update_attrs)
      assert %Ingredient{} = ingredient
      assert ingredient.name == "some updated name"
      assert ingredient.location == "some updated location"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Ingredients.update_ingredient(ingredient, @invalid_attrs)

      assert ingredient == Ingredients.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Ingredients.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Ingredients.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Ingredients.change_ingredient(ingredient)
    end
  end
end
