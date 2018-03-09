require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, %{}, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("dish", %{"action" => "add", "id" => id}, socket) do
    broadcast!(socket, "dish", %{body: %{action: "add", id: id}})
    {:noreply, socket}
  end

  def handle_in("dish", %{"action" => "remove", "id" => id}, socket) do
    broadcast!(socket, "dish", %{body: %{action: "remove", id: id}})
    {:noreply, socket}
  end
end
