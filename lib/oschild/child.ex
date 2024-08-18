defmodule Oschild.Child do
  @moduledoc """
  API for a system of 4-year-old children.

  Functions of this module require that a Child.Application is already running.
  """

  alias Oschild.Child.Core
  alias Oschild.Child.Server, as: ChildServer
  alias Oschild.Child.Supervisor, as: ChildSupervisor

  # Types

  @typedoc """
  An activity of a child.
  """
  @type activity() :: Core.activity()

  @typedoc """
  An action recognized by a child.
  """
  @type action() :: Core.action()

  @typedoc """
  A child.
  """
  @type t() :: %{
          name: String.t(),
          activity: activity(),
          mood: non_neg_integer(),
          snacks: non_neg_integer()
        }

  # Functions

  @spec all() :: list(pid())
  def all(), do: ChildSupervisor.find_all()

  @spec get(String.t()) :: pid()
  defdelegate get(child_name), to: ChildSupervisor, as: :get_child

  @spec get_state(GenServer.server()) :: t()
  def get_state(server) do
    server
    |> ChildServer.current_state()
    |> to_map()
  end

  @spec give_snack(GenServer.server()) :: {:ok, non_neg_integer()} | {:error, non_neg_integer()}
  def give_snack(server), do: ChildServer.give_snacks(server, 1)

  @spec call_to_play(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_play(server), do: ChildServer.call_to(server, :play)

  @spec call_to_eat(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_eat(server), do: ChildServer.call_to(server, :eat)

  @spec call_to_kindergarten(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_kindergarten(server), do: ChildServer.call_to(server, :kindergarten)

  # Private functions

  defp to_map({name, child = %Core{}}) do
    %{
      name: name,
      activity: child.activity,
      mood: child.mood,
      snacks: child.snacks
    }
  end
end
