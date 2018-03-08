require IEx

defmodule MaterialsCli.Data do
  NimbleCSV.define(MyParser, separator: "\t", escape: "\"")

  alias Materials.{Ingredients, Dishes, Meals, Wunderlist}

  def load_board_from_csv do
    # {:ok, board} = Board.start_link("test")
    []
    |> add_ingredients()
    |> add_dishes()
    |> add_meals()

    shopping_list(Materials.Meals.list_meals())
    |> Enum.map(fn d -> Wunderlist.add_task(preferred_list_id(), d) end)
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

  def preferred_list_id, do: Application.get_env(:material, :list_id)

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
