defmodule ChatterEcto.MessageTest do
  use ExUnit.Case

  alias ChatterEcto.Message
  alias ChatterEcto.Repo

  doctest Message

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ChatterEcto.Repo)
  end

  describe ".messages" do
    test "returns a collection of messages" do
      message = Repo.insert! %Message{
        username: "Fixture",
        message: "Hello, world!",
        room: "lobby"
      }

      assert ChatterEcto.messages("lobby") == [message]
    end
  end

  describe ".create_message" do
    test "save a message and retrieve it again" do
      message = %Message{
        username: "Fixture",
        message: "Hello, world!",
        room: "lobby"
      }
      ChatterEcto.create_message({"Fixture", "Hello, world!"})

      result = Enum.map(ChatterEcto.messages, &(&1.username))

      assert result == ["Fixture"]
    end
  end
end
