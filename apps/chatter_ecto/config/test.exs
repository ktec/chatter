use Mix.Config

# Configure your database
config :chatter_ecto, ChatterEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "chatter_ecto_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
