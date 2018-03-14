defmodule Trax.GameSupervisor do

  def start_server(game_id) do
    spec = {Trax.GameServer, [game_id]}
    IO.puts "trying to start #{game_id}"
    IO.inspect DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
