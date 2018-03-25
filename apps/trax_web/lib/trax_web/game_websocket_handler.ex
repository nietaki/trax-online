defmodule TraxWeb.GameWebsocketHandler do
  @behaviour :cowboy_websocket_handler

  alias Trax.GameServer
  alias Trax.Message

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
    GameServer.add_participant(server_pid, websocket_id)
    # TODO monitor the game server and suicide if it dies
    {:ok, req, state}
  end


  def websocket_terminate(reason, req, state) do
    %This{server_pid: server_pid, websocket_id: websocket_id} = state
    info(req, "disconnected with reason #{inspect(reason)}")
    GameServer.remove_participant(server_pid, websocket_id)
    :ok
  end


  #===========================================================================
  # Core callbacks
  #===========================================================================

  def websocket_handle({:text, content}, req, state) do
    %This{server_pid: server_pid, websocket_id: websocket_id} = state
    info(req, "handling \"#{content}\"")
    with {:ok, message} <- Message.parse(content),
         {:ok, _reply} <- GameServer.perform_action(server_pid, websocket_id, message)
    do
      Logger.info("message accepted: \"#{content}\"")
      {:ok, req, state}
    else
      _other ->
        Logger.warn("invalid message sent from client: \"#{content}\"")
        {:ok, req, state}
    end
  end

  def websocket_info({:send_out, message = %Message{}}, req, state) do
    info(req, "sending out #{inspect message}")
    {:ok, frame} = Message.encode(message)
    {:reply, {:text, frame}, req, state}
  end

  def websocket_info(info, req, state) do
    info(req, "received unexpected info #{inspect info}")
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
