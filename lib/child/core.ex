defmodule Child.Core do
  @moduledoc """
  A 4-year-old child.
  """

  @typedoc """
  The state of a child.

  A child is alaways engaged in an activity. He may have snacks and
  has a mood measured as an integer value (high means better).
  """
  @type t() :: %__MODULE__{
          activity: Child.activity(),
          mood: non_neg_integer(),
          snacks: non_neg_integer()
        }
  defstruct(
    activity: :playing,
    mood: 0,
    snacks: 0
  )

  @typedoc """
  An action recognized by a child.
  """
  @type action() :: :play | :eat | :kindergarten

  @doc "Wake up a new child ready to play."
  @spec wake_up() :: t()
  def wake_up, do: %__MODULE__{}

  @doc """
  Give snacks to a child.

  Snacks are given only when the child is playing or eating.
  """
  @spec give_snacks(t(), pos_integer()) :: t()
  def give_snacks(child = %{activity: activity, snacks: snacks}, amount)
      when activity in [:playing, :eating] and is_integer(amount) and amount > 0 do
    %__MODULE__{child | snacks: snacks + amount}
  end

  def give_snacks(child = %__MODULE__{}, _amount), do: child

  @doc """
  Call a child to perform an action.

  Returns a new child when the transition was successfully, `nil` otherwise.

  Transitioning from eating to playing consumes all the given snacks,
  Any transition involves a change in mood.
  """
  @spec call_to(t(), Child.action()) :: t() | nil
  def call_to(child = %{activity: activity}, action) do
    activity
    |> next_activity(action)
    |> do_transition(child)
  end

  @doc """
  Call a child to perform an action.

  This is the same as calling `call_to/2`, but raises an
  error when the action results in an invalid transition.
  """
  @spec call_to!(t(), Child.action()) :: t()
  def call_to!(child, action) do
    case call_to(child, action) do
      nil -> raise("Impossible transition")
      new_child -> new_child
    end
  end

  # returns the next activity if the transition is possible, nil otherwise

  defp next_activity(_current_activity, _action = :kindergarten), do: :hiding
  defp next_activity(_current_activity = :playing, _action = :eat), do: :eating

  defp next_activity(current_activity, _action = :play)
       when current_activity in [:eating, :hiding],
       do: :playing

  defp next_activity(_current_activity, _action), do: nil

  # transition to a new activity (i.e. the result from a call to next_activity)

  defp do_transition(_next_activity = nil, _child), do: nil

  defp do_transition(next_activity, child) do
    child
    |> consume_snacks(next_activity)
    |> Map.put(:activity, next_activity)
  end

  # consume the given snacks and update the mood

  defp consume_snacks(
         child = %{activity: :eating, mood: mood, snacks: snacks},
         _next_activity = :playing
       )
       when is_integer(snacks) and snacks > 1 do
    new_mood = Enum.reduce(1..snacks, mood, &raise_mood(&1 + 1, &2))

    %__MODULE__{
      child
      | snacks: 0,
        mood: new_mood
    }
  end

  defp consume_snacks(child, _next_activity = :hiding), do: %__MODULE__{child | mood: 0}
  defp consume_snacks(child, _next_activity), do: child

  # raise the mood based on the number of consumed snacks

  defp raise_mood(snacks, mood) when is_integer(snacks) and snacks == 15, do: mood + 8
  defp raise_mood(snacks, mood) when is_integer(snacks) and snacks == 5, do: mood + 4
  defp raise_mood(snacks, mood) when is_integer(snacks) and snacks == 3, do: mood + 2
  defp raise_mood(snacks, mood) when is_integer(snacks) and snacks > 0, do: mood + 1
  defp raise_mood(_snacks, mood), do: mood
end
