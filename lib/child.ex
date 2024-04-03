defmodule Child do
  @moduledoc """
  API for a system of 4-year-old children.

  Functions of this module require that a Child.Application is already running.
  """

  # Types

  @typedoc """
  A state of a child.
  """
  @type state() :: :playing | :eating | :hiding

  @typedoc """
  Return value of `call_to_*` functions.
  """
  @type on_call_to() :: {:ok, state()} | {:error, state()}

  # Functions

  @spec all() :: list(state())
  def all() do
    Child.Supervisor.find_all()
    |> Enum.map(fn pid -> {pid, Child.Server.current_activity(pid)} end)
  end

  @spec get(String.t()) :: pid()
  defdelegate get(child_name), to: Child.Supervisor, as: :get_child

  @spec current_activity(GenServer.server()) :: state()
  defdelegate current_activity(server), to: Child.Server

  @spec call_to_play(GenServer.server()) :: on_call_to()
  def call_to_play(server), do: Child.Server.call_to(server, :play)

  @spec call_to_eat(GenServer.server()) :: on_call_to()
  def call_to_eat(server), do: Child.Server.call_to(server, :eat)

  @spec call_to_kindergarten(GenServer.server()) :: on_call_to()
  def call_to_kindergarten(server), do: Child.Server.call_to(server, :kindergarten)
end
