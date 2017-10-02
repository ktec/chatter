defmodule ChatterEcto.Repo.Migrations.Message do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :username, :string, null: false
      add :message, :string, null: false

      timestamps()
    end
  end
end
