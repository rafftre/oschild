defmodule Child do
  @moduledoc """
  A 4-year-old child.
  """

  @type action :: :play | :eat | :kindergarten

  @type state :: :playing | :eating | :hiding

  @type t :: %__MODULE__{
          state: state
        }
  defstruct(state: :playing)

  @doc "Wake up a new child ready to play."
  @spec wake_up() :: t
  def wake_up, do: %__MODULE__{}

  @doc """
  Call a child to perform an action.

  Raise an error if the action causes an invalid transition.
  """
  @spec call_to!(t, action) :: t
  def call_to!(child = %{state: state}, action) do
    case state_transition(state, action) do
      {:ok, new_state} -> %__MODULE__{child | state: new_state}
      {:error} -> raise("Impossible transition")
    end
  end

  defp state_transition(_state, :kindergarten), do: {:ok, :hiding}
  defp state_transition(_state = :playing, :eat), do: {:ok, :eating}
  defp state_transition(state, :play) when state in [:eating, :hiding], do: {:ok, :playing}
  defp state_transition(_, _), do: {:error}
end
