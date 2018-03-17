defmodule Trax.GameSupervisor do
  require Logger

  def lazy_start_server(game_id) do
    case Trax.GameRegistry.lookup_game_server(game_id) do
      {:ok, pid} ->
        Logger.info "Game #{game_id} already started!"
        {:ok, pid}
      {:error, :not_found} ->
        {:ok, server_pid} = start_server(game_id)
        true = is_pid(server_pid)
        {:ok, server_pid}
    end
  end

  defp start_server(game_id) do
    spec = {Trax.GameServer, [game_id]}
    Logger.info "Starting game #{game_id}"
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
