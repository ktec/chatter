defmodule ChatterEcto.Application do
  @moduledoc """
  The ChatterEcto Application Service.

  The chatter_ecto system business domain lives in this application.

  Exposes API to clients such as the `ChatterEctoWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(ChatterEcto.Repo, []),
    ], strategy: :one_for_one, name: ChatterEcto.Supervisor)
  end
end
