defmodule Oschild.Child.Server do
  @moduledoc """
  A server process managing a single child.
  """

  require Logger

  alias Oschild.Child.Core

  use GenServer, restart: :temporary

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: global_name(name))
  end

  @spec current_state(GenServer.server()) :: {String.t(), Core.t()}
  def current_state(server) do
    GenServer.call(server, {:current_state})
  end

  @spec give_snacks(GenServer.server(), pos_integer()) ::
          {:ok, non_neg_integer()} | {:error, non_neg_integer()}
  def give_snacks(server, amount) do
    GenServer.call(server, {:give_snacks, amount})
  end

  @spec call_to(GenServer.server(), Core.action()) ::
          {:ok, Core.activity()} | {:error, Core.activity()}
  def call_to(server, action) do
    GenServer.call(server, {:call_to, action})
  end

  @spec whereis(String.t()) :: pid() | nil
  def whereis(name) do
    Logger.debug("Searching #{name}")

    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  # Callbacks

  @impl true
  def init(name) do
    Logger.debug("Waking up #{name}")
    {:ok, {name, Core.wake_up()}}
  end

  @impl true
  def handle_call({:current_state}, _from, {name, child}) do
    Logger.debug("Retrieving current activity of #{name}")
    {:reply, {name, child}, {name, child}}
  end

  @impl true
  def handle_call({:give_snacks, amount}, _from, {name, child}) do
    Logger.debug("Giving #{amount} snack(s) to #{name}")

    new_child = Core.give_snacks(child, amount)

    result =
      cond do
        child.snacks == new_child.snacks -> {:error, new_child.snacks}
        true -> {:ok, new_child.snacks}
      end

    {:reply, result, {name, new_child}}
  end

  @impl true
  def handle_call({:call_to, action}, _from, {name, child}) do
    Logger.debug("Calling #{name} to #{action}")

    case Core.call_to(child, action) do
      nil -> {:reply, {:error, child.activity}, {name, child}}
      new_child -> {:reply, {:ok, new_child.activity}, {name, new_child}}
    end
  end

  # Private functions

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end
end
