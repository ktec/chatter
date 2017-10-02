defmodule ChatterEcto do
  @moduledoc """
  ChatterEcto keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import ChatterEcto.Repo
  import Ecto.Query
  alias ChatterEcto.Message

  @doc """
  Retrieve a list of messages.
  """
  @spec messages() :: [Message.t]
  def messages do
    all(Message)
  end

  @doc """
  Retrieve a list of messages scoped by room.
  """
  @spec messages(binary) :: [Message.t]
  def messages(room) do
    Message |> where(room: ^room) |> all()
  end

  @doc """
  Create a message.
  """
  @spec create_message({binary, binary}) :: Message.t
  def create_message({username, message}) do
    insert(%Message{username: username, message: message, room: "lobby"})
  end

  @doc """
  Create a message.
  """
  @spec create_message({binary, binary, binary}) :: Message.t
  def create_message({username, message, room}) do
    insert(%Message{username: username, message: message, room: room})
  end
end
