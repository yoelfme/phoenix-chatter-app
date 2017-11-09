defmodule ChatterWeb.RoomChannel do
  use ChatterWeb, :channel
  alias ChatterWeb.Presence

  def join("room:lobby", _, socket) do
    
    if socket.assigns.user == "" do
      { :error, %{ reason: "Invalid user" }}
    else
      send self(), :after_join
      {:ok, socket}
    end
  end

  # def handle_info(:after_join, socket) do
  #   push socket, "presence_state", Presence.list(socket)
  #   {:ok, _} = Presence.track(socket, socket.assigns.user, %{
  #     online_at: inspect(System.system_time(:seconds))
  #   })
  #   {:noreply, socket}
  # end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    push socket, "presence_state", Presence.list(socket)

    { :noreply, socket }
  end

  def handle_in("message:new", payload, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: payload,
      timestamp: :os.system_time(:milli_seconds)
    }

    { :noreply, socket }
  end
  

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
