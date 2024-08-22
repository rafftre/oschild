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
  @type t() :: map()

  # Functions

  @spec change_child(Core.t(), map()) :: Ecto.Changeset.t()
  def change_child(child, attrs \\ %{}) do
    Core.changeset(child, attrs)
  end

  @spec all() :: list(pid())
  def all(), do: ChildSupervisor.find_all()

  @spec get(String.t()) :: pid()
  defdelegate get(child_name), to: ChildSupervisor, as: :get_child

  @spec get_state(GenServer.server()) :: t()
  def get_state(server) do
    server
    |> ChildServer.current_state()
    |> Map.from_struct()
  end

  @spec give_snack(GenServer.server()) :: {:ok, non_neg_integer()} | {:error, non_neg_integer()}
  def give_snack(server), do: ChildServer.give_snacks(server, 1)

  @spec call_to_play(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_play(server), do: ChildServer.call_to(server, :play)

  @spec call_to_eat(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_eat(server), do: ChildServer.call_to(server, :eat)

  @spec call_to_kindergarten(GenServer.server()) :: {:ok, activity()} | {:error, activity()}
  def call_to_kindergarten(server), do: ChildServer.call_to(server, :kindergarten)
end
