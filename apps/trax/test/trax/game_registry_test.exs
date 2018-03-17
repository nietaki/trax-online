defmodule Trax.GameRegistryTest do
  use ExUnit.Case, async: true

  alias Trax.GameRegistry, as: GR

  test "registering a game server" do
    assert {:ok, _} = GR.register_game_server(Nanoid.generate())
  end

  test "looking up a game server" do
    foo = Nanoid.generate()
    bar = Nanoid.generate()

    server_pid = register_another_pid_as(foo)

    assert {:ok, ^server_pid} = GR.lookup_game_server(foo)
    assert {:error, :not_found} = GR.lookup_game_server(bar)
  end

  test "registering multiple servers as the same game_id" do
    game_id = Nanoid.generate()
    previous_server = register_another_pid_as(game_id)

    assert {:error, {:already_registered, ^previous_server}} = GR.register_game_server(game_id)
  end


  #===========================================================================
  # Helper functions
  #===========================================================================

  defp register_another_pid_as(game_id) do
    test_pid = self()
    server_pid = spawn fn ->
      GR.register_game_server(game_id)
      send test_pid, :ready
      receive do
        :wont_happen -> :ok
      end
    end

    receive do
      :ready -> :ok
    end
    server_pid
  end

end
