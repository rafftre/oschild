defmodule Nanny do
  @moduledoc """
  A supervisor providing child care.
  """

  use DynamicSupervisor

  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec find_child(String.t()) :: pid()
  def find_child(name) do
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
