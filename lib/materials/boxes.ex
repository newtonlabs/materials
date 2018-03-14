require IEx

defmodule Materials.Boxes do
  import Ecto.Query, warn: false
  alias Materials.{Repo, Box}

  def create_box(attrs \\ %{}) do
    %Box{}
    |> Box.changeset(attrs)
    |> Repo.insert()
  end

  def shopping_list(sections) do
    sections
    |> Enum.flat_map(fn section ->
      Enum.flat_map(section.cards, fn card ->
        card.ingredients
      end)
    end)
    |> Enum.group_by(&task_name/1, &task_name/1)
    |> Enum.map(fn {{id, name}, value} ->
      %{id: id, name: task_quantity(name, length(value))}
    end)
  end

  def task_name(ingredient) do
    {ingredient.id, "#{ingredient.location} - #{ingredient.name}"}
  end

  def task_quantity(task, quantity) when quantity > 1, do: "#{task} (#{quantity})"
  def task_quantity(task, _), do: "#{task}"
end
