require IEx

defmodule MaterialsCli.Data do
  NimbleCSV.define(MyParser, separator: "\t", escape: "\"")

  alias Materials.{Cards, Boxes, Ingredients, Wunderlist, Repo}
  alias Materials.{Card, Box, Ingredient}

  def load_board_from_csv(section) do
    clean_up()

    errors =
      []
      |> add_ingredients()
      |> add_cards(section)
  end

  def clean_up() do
    Repo.delete_all(Card)
    Repo.delete_all(Ingredient)
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

  def add_cards(errors, section) do
    "data/cards.tsv"
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [dish_name, csv_ingredients] ->
      Cards.create_card(%{name: dish_name, ingredients: csv_ingredients, section_id: section.id})
    end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.concat(errors)
  end
end
