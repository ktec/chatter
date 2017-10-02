defmodule ChatterWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _payload, socket) do
    messages = get_messages("lobby")
    {:ok, messages, socket}
  end

  def join("room:" <> room, _payload, socket) do
    socket = assign(socket, :room, room)
    messages = get_messages(room)
    {:ok, messages, socket}
  end

  def handle_in("new_message", %{"body" => body, "user" => user} = payload, socket) do
    room = socket.assigns[:room]
    Process.spawn(fn ->
      ChatterEcto.create_message({user, body, room})
    end, [])
    broadcast! socket, "new_message", payload
    {:noreply, socket}
  end

  # convert the database response to what the view expects!
  defp get_messages(room) do
    ChatterEcto.messages(room)
    |> Enum.map(&(%{user: &1.username, body: &1.message}))
  end
end
