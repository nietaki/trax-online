defmodule TraxWeb.GameWebsocketHandler do
  @behaviour :cowboy_websocket_handler

  alias Trax.GameServer

  alias __MODULE__, as: This
  require Logger

  @moduledoc """
  See here for the implementation inspiration:
  https://github.com/IdahoEv/cowboy-elixir-example/blob/cowboy_1/lib/websocket_handler.ex

  See here for the weirdly formatted docs:
  https://ninenines.eu/docs/en/cowboy/1.0/manual/cowboy_websocket_handler/
  """

  defstruct [
    :game_id,
    :server_pid,
    :websocket_id,
  ]

  #===========================================================================
  # One-time callbacks
  #===========================================================================

  def init({_tcp, _http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end


  def websocket_init(_transport_name, req, _opts) do
    info(req, "connected")
    game_id = get_game_id(req)
    websocket_id = Nanoid.generate()
    {:ok, server_pid} = Trax.GameSupervisor.lazy_start_server(game_id)
    state = %This{
      game_id: game_id,
      server_pid: server_pid,
      websocket_id: websocket_id,
    }
    GameServer.register_participant(server_pid, websocket_id)
    # TODO monitor the game server and suicide if it dies
    {:ok, req, state}
  end


  def websocket_terminate(reason, req, _state) do
    info(req, "disconnected with reason #{inspect(reason)}")
    :ok
  end


  #===========================================================================
  # Core callbacks
  #===========================================================================

  def websocket_handle({:text, content}, req, state) do
    info(req, "handling \"#{content}\"")
    reply = "cowboy replying to '#{content}'!"
    {:reply, {:text, reply}, req, state}
  end


  def websocket_info(info, req, state) do
    info(req, "received info #{inspect info}")
    {:ok, req, state}
  end

  #===========================================================================
  # Helpers
  #===========================================================================

  defp get_path(req) do
    req |> Tuple.to_list() |> Enum.at(11)
  end

  defp get_game_id(req) do
    req |> Tuple.to_list() |> Enum.at(15) |> Keyword.fetch!(:game_id)
  end


  defp info(req, message) do
    path = get_path(req)
    Logger.info("ws for #{path} #{message}")
  end

end
