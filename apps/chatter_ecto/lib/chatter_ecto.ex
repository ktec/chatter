defmodule ChatterEcto do
  @moduledoc """
  ChatterEcto keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import ChatterEcto.Repo
  alias ChatterEcto.Message

  @doc """
  Retrieve a list of messages.
  """
  @spec messages() :: [Message.t]
  def messages do
    all(Message)
  end

  @doc """
  Create a message.
  """
  @spec create_message({binary, binary}) :: Message.t
  def create_message({username, message}) do
    insert(%Message{username: username, message: message})
  end
end
