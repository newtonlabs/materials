require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel
  alias Materials.{Dishes, Meals, Repo, Meal}

  def join("room:lobby", _message, socket) do
    {:ok, %{}, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("dish", %{"action" => "add", "id" => id}, socket) do
    dish = Dishes.get_dish!(id)
    meal = get_meal()

    {:ok, meal} = Meals.update_meal(meal, %{dishes: [dish] ++ meal.dishes})

    # TODO this is broken, need to get the specfic meal and fix this
    shopping_list =
      Meals.list_meals()
      |> Meals.shopping_list()

    broadcast!(socket, "dish", %{list: shopping_list})
    {:noreply, socket}
  end

  def handle_in("dish", %{"action" => "remove", "id" => id}, socket) do
    dish = Dishes.get_dish!(id)
    meal = get_meal()

    dishes =
      meal.dishes
      |> Enum.filter(&("#{&1.id}" != id))

    {:ok, meal} = Meals.update_meal(meal, %{dishes: dishes})

    # TODO this is broken, need to get the specfic meal and fix this
    shopping_list =
      Meals.list_meals()
      |> Meals.shopping_list()

    broadcast!(socket, "dish", %{list: shopping_list})
    {:noreply, socket}
  end

  def get_meal do
    List.first(Repo.all(Meal)) |> Repo.preload([:dishes])
  end
end
