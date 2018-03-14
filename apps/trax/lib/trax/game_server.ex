defmodule Trax.GameServer do
  use GenServer

  @impl true
  def init([game_id]) do
    IO.puts "starting game server #{game_id}"
    {:ok, game_id}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end
end
