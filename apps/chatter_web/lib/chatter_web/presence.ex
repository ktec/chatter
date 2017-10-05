defmodule ChatterWeb.Presence do
  use Phoenix.Presence, otp_app: :particle_web,
                        pubsub_server: ChatterWeb.PubSub
end
