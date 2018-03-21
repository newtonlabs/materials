require Logger
require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel
  alias Materials.{Cards, Users, Ingredients}

  def join("room:lobby", _message, socket) do
    {:ok, %{}, socket}
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

  def handle_in("add_ingredient:" <> card_id, %{"name" => components}, socket) do
    # Check for new ingredients, create if necessary
    {:ok, ingredient} = Ingredients.upsert_ingredient_from_components(components)
    card = Cards.get_full_card!(card_id)

    # Remove any duplicates and update
    ingredients = Enum.filter(card.ingredients, &(&1.name != ingredient.name))
    {:ok, resp} = Cards.update_card(card, %{ingredients: ingredients ++ [ingredient]})

    # Broadcast changes
    broadcast!(socket, "cards", %{shopping_list: Users.shopping_list()})
    {:reply, {:ok, resp}, socket}
  end

  def handle_in("remove_ingredient:" <> card_id, %{"name" => name}, socket) do
    # Get the card and slim down the ingredients list
    card = Cards.get_full_card!(card_id)
    ingredients = card.ingredients |> Enum.filter(&(&1.name != name))
    {:ok, resp} = Cards.update_card(card, %{ingredients: ingredients})

    # Broadcast
    broadcast!(socket, "cards", %{shopping_list: Users.shopping_list()})
    {:reply, {:ok, resp}, socket}
  end
end
