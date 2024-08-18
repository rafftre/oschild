defmodule Oschild.Child.Supervisor do
  @moduledoc """
  A supervisor providing child care.
  """

  alias Oschild.Child.Server, as: ChildServer

  use DynamicSupervisor

  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Returns a list with the `pid` of each running child process.
  """
  @spec find_all() :: list(pid())
  def find_all() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {_id, pid, _type, _modules} -> pid end)
    |> Enum.filter(fn pid -> pid != :restarting end)
  end

  @doc """
  Returns the `pid` for the child process.

  Creates a new process if it is not running.
  """
  @spec get_child(String.t()) :: pid()
  def get_child(name) do
    awakened_child(name) || wake_up_child(name)
  end

  # Callbacks

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Private

  defp awakened_child(name), do: ChildServer.whereis(name)

  defp wake_up_child(name) do
    case DynamicSupervisor.start_child(__MODULE__, {ChildServer, name}) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
