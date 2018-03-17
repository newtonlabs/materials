require Logger
require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel
  alias Materials.{Cards, Users}

  def join("room:lobby", _message, socket) do
    {:ok, %{}, socket}
    # {:ok, shopping_list(), socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("section:" <> section_id, %{"card_id" => card_id}, socket) do
    {:ok, _card} =
      Cards.get_card!(card_id)
      |> Cards.update_card(%{section_id: section_id})

    broadcast!(socket, "cards", %{shopping_list: Users.shopping_list()})
    {:noreply, socket}
  end

  def handle_in("update_card:" <> card_id, %{"body" => body, "name" => name}, socket) do
    {:ok, resp} =
      Cards.get_full_card!(card_id)
      |> Cards.update_card(%{body: body, name: name})

    {:reply, {:ok, resp}, socket}
  end

  def handle_in("cards:" <> card_id, _payload, socket) do
    resp =
      card_id
      |> String.to_integer()
      |> Cards.get_full_card!()

    {:reply, {:ok, resp}, socket}
  end

  def handle_in("add_ingredient:" <> card_id, %{"name" => name}, socket) do
    card = Cards.get_full_card!(card_id)

    # TODO Ugly Hack!
    names = Enum.reduce(card.ingredients, "", fn val, acc -> acc <> val.name <> "," end) <> name
    {:ok, resp} = Cards.update_card(card, %{ingredients: names})
    broadcast!(socket, "cards", %{shopping_list: Users.shopping_list()})
    {:reply, {:ok, resp}, socket}
  end

  def handle_in("remove_ingredient:" <> card_id, %{"name" => name}, socket) do
    card = Cards.get_full_card!(card_id)

    # TODO Ugly Hack!
    names =
      card.ingredients
      |> Enum.filter(&(&1.name != name))
      |> Enum.reduce("", fn val, acc -> acc <> val.name <> "," end)

    {:ok, resp} = Cards.update_card(card, %{ingredients: names})
    broadcast!(socket, "cards", %{shopping_list: Users.shopping_list()})
    {:reply, {:ok, resp}, socket}
  end

  # def shopping_list do
  #   # TODO this is broken, need to get the specfic meal and fix this
  #   meal = List.first(Meals.list_meals())
  #
  #   %{
  #     list: Meals.shopping_list([meal]),
  #     dishes: meal.dishes
  #   }
  # end
end
