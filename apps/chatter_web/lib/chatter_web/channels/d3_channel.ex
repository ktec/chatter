defmodule ChatterWeb.D3Channel do
  use Phoenix.Channel

  def join("d3:particles", payload, socket) do
    # convert the database response to what the view expects!
    # socket = assign(socket, :room, room)
    {:ok, payload, socket}
  end

  def handle_in("position", payload, socket) do
    broadcast! socket, "position", payload
    {:noreply, socket}
  end
end
