require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel
  alias Materials.{Dishes, Meals, Repo, Meal}

  def join("room:lobby", _message, socket) do
    {:ok, %{}, socket}
    # {:ok, shopping_list(), socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("dish", %{"action" => "add", "id" => id}, socket) do
    dish = Dishes.get_dish!(id)
    meal = get_meal()

    {:ok, _meal} = Meals.update_meal(meal, %{dishes: [dish] ++ meal.dishes})

    broadcast!(socket, "dish", shopping_list())
    {:noreply, socket}
  end

  def handle_in("dish", %{"action" => "remove", "id" => id}, socket) do
    meal = get_meal()

    dishes =
      meal.dishes
      |> Enum.filter(&("#{&1.id}" != id))

    {:ok, _meal} = Meals.update_meal(meal, %{dishes: dishes})

    broadcast!(socket, "dish", shopping_list())
    {:noreply, socket}
  end

  def get_meal do
    List.first(Repo.all(Meal)) |> Repo.preload([:dishes])
  end

  def shopping_list do
    # TODO this is broken, need to get the specfic meal and fix this
    %{list: Meals.list_meals() |> Meals.shopping_list()}
  end
end
