use Mix.Config

config :chatter_ecto, ecto_repos: [ChatterEcto.Repo]

import_config "#{Mix.env}.exs"
