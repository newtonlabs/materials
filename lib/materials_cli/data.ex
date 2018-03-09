require IEx

defmodule MaterialsCli.Data do
  NimbleCSV.define(MyParser, separator: "\t", escape: "\"")

  alias Materials.{Ingredients, Dishes, Meals, Wunderlist, Repo}

  def load_board_from_csv do
    clean_up()

    _errors =
      []
      |> add_ingredients()
      |> add_dishes()
      |> add_meals()

    Meals.list_meals()
    |> Meals.shopping_list()
  end

  def clean_up() do
    Repo.delete_all(Materials.Meal)
    Repo.delete_all(Materials.Dish)
    Repo.delete_all(Materials.Ingredient)
  end

  def add_ingredients(errors) do
    "data/ingredients.tsv"
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [name, frequency, location] ->
      Ingredients.create_ingredient(%{name: name, frequency: frequency, location: location})
    end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.concat(errors)
  end

  def add_dishes(errors) do
    "data/dishes.tsv"
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [dish_name, csv_ingredients] ->
      Dishes.create_dish(%{name: dish_name, ingredients: csv_ingredients})
    end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.concat(errors)
  end

  def add_meals(errors) do
    "data/planner.tsv"
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [name, csv_dishes] ->
      Meals.create_meal(%{name: name, dishes: csv_dishes})
    end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.concat(errors)
  end
end
