defmodule Trax.GameServer do
  use GenServer

  require Logger

  alias Trax.GameLogic
  alias Trax.Message

  defmodule State do
    defstruct [
      :game_id,
      :game_state,
      :participants,
    ]


    def new(game_id) do
      {:ok, game_state} = GameLogic.init(game_id)
      %__MODULE__{
        game_id: game_id,
        game_state: game_state,
        participants: %{},
      }
    end
  end

  #---------------------------------------------------------------------------
  # Initialisation
  #---------------------------------------------------------------------------

  @impl true
  def init([game_id]) do
    Logger.info "starting game server #{game_id}"
    {:ok, _} = Trax.GameRegistry.register_game_server(game_id)
    {:ok, State.new(game_id)}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  #---------------------------------------------------------------------------
  # Public Interface
  #---------------------------------------------------------------------------

  def add_participant(game_server_pid, websocket_id) do
    GenServer.cast(game_server_pid, {:add_participant, websocket_id, self()})
  end


  def remove_participant(game_server_pid, websocket_id) do
    GenServer.cast(game_server_pid, {:remove_participant, websocket_id})
  end


  def perform_action(game_server_pid, websocket_id, message = %Message{}) do
    game_state = GenServer.call(game_server_pid, {:perform_action, websocket_id, message})
    {:ok, game_state}
  end

  #---------------------------------------------------------------------------
  # Callbacks
  #---------------------------------------------------------------------------

  @impl true
  def handle_cast({:add_participant, websocket_id, websocket_pid}, state) do
    Logger.info "adding #{websocket_id} as a participant in #{state.game_id}"
    new_participants = Map.put(state.participants, websocket_id, websocket_pid)
    {:ok, game_state} = GameLogic.add_participant(state.game_state, websocket_id)
    new_state = %State{state | participants: new_participants, game_state: game_state}
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:remove_participant, websocket_id}, state) do
    Logger.info "removing #{websocket_id} from participants in #{state.game_id}"
    participants = Map.delete(state.participants, websocket_id)
    {:ok, game_state} = GameLogic.remove_participant(state.game_state, websocket_id)
    new_state = %State{state | participants: participants, game_state: game_state}
    {:noreply, new_state}
  end


  @impl true
  def handle_call({:perform_action, websocket_id, message}, _from, state) do
    {:ok, game_state} = GameLogic.perform_action(state.game_state, websocket_id, message)
    new_state = %{state | game_state: game_state}
    broadcast_msg = %Message{type: "foo", data: %{foo: :bar}, metadata: %{}}
    :ok = broadcast({:send_out, broadcast_msg}, new_state)
    {:reply, game_state, new_state}
  end

  #===========================================================================
  # Private Functions
  #===========================================================================

  # broadcasts the message to all in-game websockets
  def broadcast(message, state) do
    state.participants
    |> Enum.map(fn {_id, pid} -> pid end)
    |> Enum.each(fn pid -> send(pid, message) end)
    :ok
  end

end
