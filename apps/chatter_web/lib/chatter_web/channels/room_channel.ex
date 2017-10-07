defmodule ChatterWeb.RoomChannel do
  use Phoenix.Channel
  alias ChatterWeb.Presence

  def join("room:lobby", _payload, %{assigns: %{user_id: verified_user_id}} = socket) do
    send(self(), :after_join)
    messages = get_messages("lobby")
    {:ok, %{user_id: verified_user_id, messages: messages}, socket}
  end

  def join("room:" <> room, _payload, %{assigns: %{user_id: verified_user_id}} = socket) do
    send(self(), :after_join)
    socket = assign(socket, :room, room)
    messages = get_messages(room)
    {:ok, %{user_id: verified_user_id, messages: messages}, socket}
  end

  def join("room:lobby", _payload, %{assigns: %{}} = socket) do
    {:ok, %{error: "Token verification failed"}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  def handle_in("new_message", %{"body" => body, "user" => user} = payload, socket) do
    room = socket.assigns[:room]
    if (user != socket.assigns[:username]) do
      username = socket.assigns[:username]
      {:ok, _} = Presence.update(socket, socket.assigns.user_id, %{
        username: username
      })
    end
    Process.spawn(fn ->
      ChatterEcto.create_message({user, body, room})
    end, [])
    # send(self(), :save_message)
    broadcast! socket, "new_message", payload
    {:noreply, socket}
  end

  # def handle_in("new_message", payload, socket) do
  #   room = socket.assigns[:room]
  #   Process.spawn(fn ->
  #     ChatterEcto.create_message({user, body, room})
  #   end, [])
  #   broadcast! socket, "new_message", payload
  #   {:noreply, socket}
  # end

  # convert the database response to what the view expects!
  defp get_messages(room) do
    ChatterEcto.messages(room)
    |> Enum.map(&(%{user: &1.username, body: &1.message}))
  end
end
