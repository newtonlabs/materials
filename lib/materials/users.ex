defmodule Materials.Users do
  import Ecto.Query, warn: false
  alias Materials.{Repo, User}

  # TODO Temporary while hacking
  def get_first_user_first_box() do
    user = List.first(Repo.all(User) |> Repo.preload(:boxes))
    List.first(user.boxes)
  end

  def data_dump do
    get_first_user_first_box()
    |> Repo.preload(sections: [cards: :ingredients])
  end

  # TODO Way too expensive right now
  def shopping_list do
    Enum.find(data_dump().sections, &(&1.name == "This Week"))
    |> shopping_list()
  end

  def shopping_list(section) do
    Enum.flat_map(section.cards, fn card ->
      card.ingredients
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
