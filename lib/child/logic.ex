defmodule Child.Logic do
  @moduledoc """
  A 4-year-old child.
  """

  @type t() :: %__MODULE__{
          state: Child.state()
        }
  defstruct(state: :playing)

  @typedoc """
  An action recognized by a child.
  """
  @type action() :: :play | :eat | :kindergarten

  @doc "Wake up a new child ready to play."
  @spec wake_up() :: t()
  def wake_up, do: %__MODULE__{}

  @doc """
  Call a child to perform an action.

  Returns `{:ok, new_child}` when the transition was successfully, `{:error, child}` otherwise.
  """
  @spec call_to(t(), action()) :: {:ok, t()} | {:error, t()}
  def call_to(child = %{state: state}, action) do
    case state_transition(state, action) do
      nil -> {:error, child}
      new_state -> {:ok, %__MODULE__{child | state: new_state}}
    end
  end

  @doc """
  Call a child to perform an action.

  This is the same as calling `call_to/2`, but raises an
  error when the action results in an invalid transition.
  """
  @spec call_to!(t(), action()) :: t()
  def call_to!(child, action) do
    case call_to(child, action) do
      {:ok, new_child} -> new_child
      {:error, _child} -> raise("Impossible transition")
    end
  end

  defp state_transition(_state, :kindergarten), do: :hiding
  defp state_transition(_state = :playing, :eat), do: :eating
  defp state_transition(state, :play) when state in [:eating, :hiding], do: :playing
  defp state_transition(_, _), do: nil
end
