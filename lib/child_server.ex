defmodule ChildServer do
  @moduledoc """
  A server process managing a single child.
  """

  use GenServer

  @typedoc """
  Return values of `call_to*` functions.
  """
  @type on_call_to() :: {:ok, Child.state()} | {:error, Child.state()}

  @impl true
  def init(_) do
    {:ok, Child.wake_up()}
  end

  @impl true
  def handle_call({:current_state}, _from, child) do
    {:reply, child.state, child}
  end

  @impl true
  def handle_call({:call_to, action}, _from, child) do
    {res, new_child} = Child.call_to(child, action)
    {:reply, {res, new_child.state}, new_child}
  end

  @spec start_link() :: GenServer.on_start()
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec call_to_play(pid()) :: on_call_to()
  def call_to_play(pid) do
    GenServer.call(pid, {:call_to, :play})
  end

  @spec call_to_eat(pid()) :: on_call_to()
  def call_to_eat(pid) do
    GenServer.call(pid, {:call_to, :eat})
  end

  @spec call_to_kindergarten(pid()) :: on_call_to()
  def call_to_kindergarten(pid) do
    GenServer.call(pid, {:call_to, :kindergarten})
  end

  @spec current_activity(pid()) :: Child.state()
  def current_activity(pid) do
    GenServer.call(pid, {:current_state})
  end
end
