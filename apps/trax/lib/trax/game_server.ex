defmodule Trax.GameServer do
  require Logger

  use GenServer

  defmodule State do
    defstruct [
      :game_id,
      :participants,
    ]

    def new(game_id) do
      %__MODULE__{
        game_id: game_id,
        participants: %{},
      }
    end

    def add_participant(state = %__MODULE__{participants: participants}, websocket_id, websocket_pid) do
      %__MODULE__{state | participants: Map.put(participants, websocket_id, websocket_pid)}
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

  def register_participant(game_server_pid, websocket_id) do
    GenServer.cast(game_server_pid, {:register_participant, websocket_id, self()})
  end

  #---------------------------------------------------------------------------
  # Callbacks
  #---------------------------------------------------------------------------

  @impl true
  def handle_cast({:register_participant, websocket_id, websocket_pid}, state) do
    Logger.info "adding #{websocket_id} as a participant in #{state.game_id}"
    new_state = State.add_participant(state, websocket_id, websocket_pid)
    {:noreply, new_state}
  end

end
