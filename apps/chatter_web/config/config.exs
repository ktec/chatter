# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatter_web,
  namespace: ChatterWeb,
  ecto_repos: [ChatterWeb.Repo]

# Configures the endpoint
config :chatter_web, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bx38FAZ3KDPf+B7+Q6jxh5AzrBaz+k8ff/kSF0C/0swTsfjg+VZqHT5Rusqsyv/Q",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChatterWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :chatter_web, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
