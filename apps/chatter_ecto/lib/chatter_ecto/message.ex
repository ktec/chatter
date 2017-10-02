defmodule ChatterEcto.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :username
    field :message
    field :room

    timestamps()
  end

  def changeset(message, params \\ :empty) do
    message
    |> put_change(:room, "lobby")
    |> cast(params, [:username, :message, :room])
    |> validate_required([:username, :message])
  end
end
