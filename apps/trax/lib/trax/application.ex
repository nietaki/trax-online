defmodule Trax.Application do
  @moduledoc """
  The Trax Application Service.

  The trax system business domain lives in this application.

  Exposes API to clients such as the `TraxWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      {Registry, name: Trax.GameRegistry, keys: :unique},
      {DynamicSupervisor, strategy: :one_for_one, name: Trax.GameSupervisor},
    ], strategy: :one_for_all, name: Trax.Supervisor)
  end
end
