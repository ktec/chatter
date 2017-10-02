defmodule ChatterEcto.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :username
    field :message

    timestamps()
  end

  def changeset(message, params \\ :empty) do
    message
    |> cast(params, [:username, :message])
    |> validate_required([:username, :message])
  end
end
