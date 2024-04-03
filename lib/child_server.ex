defmodule ChildServer do
  @moduledoc """
  A server process managing a single child.
  """

  use GenServer, restart: :temporary

  @typedoc """
  Return values of `call_to*` functions.
  """
  @type on_call_to() :: {:ok, Child.state()} | {:error, Child.state()}

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: global_name(name))
  end

  @spec call_to_play(GenServer.server()) :: on_call_to()
  def call_to_play(server) do
    GenServer.call(server, {:call_to, :play})
  end

  @spec call_to_eat(GenServer.server()) :: on_call_to()
  def call_to_eat(server) do
    GenServer.call(server, {:call_to, :eat})
  end

  @spec call_to_kindergarten(GenServer.server()) :: on_call_to()
  def call_to_kindergarten(server) do
    GenServer.call(server, {:call_to, :kindergarten})
  end

  @spec current_activity(GenServer.server()) :: Child.state()
  def current_activity(server) do
    GenServer.call(server, {:current_state})
  end

  @spec whereis(String.t()) :: pid() | nil
  def whereis(name) do
    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  # Callbacks

  @impl true
  def init(name) do
    {:ok, {name, Child.wake_up()}}
  end

  @impl true
  def handle_call({:current_state}, _from, {name, child}) do
    {:reply, child.state, {name, child}}
  end

  @impl true
  def handle_call({:call_to, action}, _from, {name, child}) do
    {res, new_child} = Child.call_to(child, action)
    {:reply, {res, new_child.state}, {name, new_child}}
  end

  # Private

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end
end
