defmodule Trax.GameLogic do
  require Logger
  defstruct []

  @type state :: %__MODULE__{}


  def init(_game_id) do
    {:ok, %__MODULE__{}}
  end

  @spec add_participant(state, String.t) :: {:ok, state} | {:error, term}
  def add_participant(state, _participant_id) do
    {:ok, state}
  end


  @spec remove_participant(state, String.t) :: {:ok, state} | {:error, term}
  def remove_participant(state, _participant_id) do
    {:ok, state}
  end


  @spec perform_action(state, String.t, map) :: {:ok, state} | {:error, term}
  def perform_action(state, _participant_id, _action) do
    Logger.info("game logic performed action")
    {:ok, state}
  end

end
