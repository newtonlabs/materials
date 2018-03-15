require IEx

defmodule MaterialsTest do
  use Materials.DataCase
  alias Materials.{Boxes, Box, Card, Cards, Repo}

  describe "ingredients" do
    @card_attrs %{name: "card name", ingredients: "a,b,c"}
    @box_attrs %{name: "table name"}

    def meal_fixture(attrs \\ %{}) do
      {:ok, meal} =
        attrs
        |> Enum.into(@table_attrs)
        |> Table.create_table()

      meal
    end

    # test "create_meal/1 with valid data creates a meal" do
    #   assert {:ok, %Meal{} = _} = Meals.create_meal(@meal_attrs)
    # end

    # test "update_meal/1 with valid name updates a meal" do
    #   meal = meal_fixture()
    #   assert {:ok, meal} = Meals.update_meal(meal, %{name: "test name"})
    #   assert %Meal{} = meal
    #   assert meal.name == "test name"
    #
    #   # dish = Dishes.get_dish!(id)
    #   # meal = List.first(Repo.all(Meal)) |> Repo.preload([:dishes])
    #   # IEx.pry()
    #   # Meals.update_meal(meal, %{dishes: meal.dishes ++ dish})
    # end

    # test "update_meal/1 with dishes updates a meal" do
    #   assert {:ok, %Dish{} = dish1} = Dishes.create_dish(@dish_attrs)
    #
    #   assert {:ok, %Dish{} = dish2} =
    #            Dishes.create_dish(%{name: "dish name 2", ingredients: "a,b,c"})
    #
    #   meal = meal_fixture() |> Repo.preload(:dishes)
    #
    #   assert {:ok, meal} = Meals.update_meal(meal, %{name: "test name", dishes: [dish1]})
    #   assert %Meal{} = meal
    #   assert meal.name == "meal name"
    #   assert meal.dishes == [dish1]
    #
    #   assert {:ok, meal} = Meals.update_meal(meal, %{dishes: [dish1, dish2]})
    #   assert meal.dishes == [dish1, dish2]
    # end

    # test "some odd scenario" do
    #   assert {:ok, %Dish{} = dish1} = Dishes.create_dish(@dish_attrs)
    #
    #   dish2 = Dishes.get_dish!(dish1.id)
    #   assert dish1 == dish2
    #
    #   assert {:ok, %Dish{}} = Dishes.create_dish(%{name: "dish name 2", ingredients: "a,b,c"})
    #
    #   meal1 = meal_fixture() |> Repo.preload(:dishes)
    #   meal2 = List.first(Repo.all(Meal)) |> Repo.preload([:dishes])
    #   assert meal1 == meal2
    #
    #   {:ok, meal} = Meals.update_meal(meal2, %{dishes: [dish2]})
    #   assert meal.dishes == [dish2]
    #   # assert dishes == [dish3, dish1]
    # end
  end
end
