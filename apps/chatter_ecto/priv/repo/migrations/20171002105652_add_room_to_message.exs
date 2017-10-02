defmodule ChatterEcto.Repo.Migrations.AddRoomToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room, :string, null: false, default: "lobby"
    end
  end
end
