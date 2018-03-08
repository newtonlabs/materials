require IEx

defmodule MaterialsWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    payload = look_for_rooms(body)
    broadcast!(socket, "new_msg", %{body: payload})
    {:noreply, socket}
  end

  def look_for_rooms(body) when body == "meals" do
    Materials.Meals.list_meals()
  end

  def look_for_rooms(body), do: body

  def encode(%{__struct__: _} = struct, options) do
    map =
      struct
      |> Map.from_struct()
      |> sanitize_map

    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end
end
