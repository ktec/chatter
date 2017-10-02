use Mix.Config

# Configure your database
config :chatter_ecto, ChatterEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "chatter_ecto_dev",
  hostname: "localhost",
  pool_size: 10
