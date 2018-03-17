defmodule Trax.GameRegistry do

  def register_game_server(game_id) do
    Registry.register(__MODULE__, game_id, :irrelevant)
  end

  def lookup_game_server(game_id) do
    case Registry.lookup(__MODULE__, game_id) do
      [] ->
        {:error, :not_found}
      [{pid, _value}] ->
        {:ok, pid}
    end
  end

end
