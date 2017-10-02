defmodule ChatterWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _payload, socket) do
    # convert the database response to what the view expects!
    messages = ChatterEcto.messages
               |> Enum.map(&(%{user: &1.username, body: &1.message}))
    {:ok, messages, socket}
  end

  def handle_in("new_message", %{"body" => body, "user" => user} = payload, socket) do
    Process.spawn(fn ->
      ChatterEcto.create_message({user, body})
    end, [])
    broadcast! socket, "new_message", payload
    {:noreply, socket}
  end
end
