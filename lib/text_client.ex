defmodule TextClient do
  @actions [:play, :eat, :kindergarten]

  def start() do
    try do
      interact()
    catch
      :throw, :exit -> IO.puts("Exiting")
    end
  end

  defp interact() do
    children = Child.all()

    display_playground(children)
    child = Enum.at(children, select_child_index(), Enum.at(children, 0))

    display_actions(@actions)
    action = Enum.at(@actions, select_action_index(), Enum.at(@actions, 0))

    res = call_to(child, action)
    display_call_result(action, res)

    interact()
  end

  defp display_playground([]), do: IO.puts("Playground is empty.")

  defp display_playground(children) do
    IO.puts([
      "In the playground there are ",
      children
      |> Stream.map(fn child -> child |> Child.get_state() |> child_state_as_string() end)
      |> Stream.with_index()
      |> Stream.map(fn {x, i} -> "#{i}: #{x}" end)
      |> Enum.join(", ")
    ])
  end

  defp child_state_as_string(%{name: name, activity: activity, mood: mood, snacks: snacks}) do
    "#{name}|#{Atom.to_string(activity)}|#{mood}|#{snacks}"
  end

  defp display_actions(actions) do
    IO.puts([
      "Calls are ",
      actions
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> "#{i}: #{x}" end)
      |> Enum.join(", ")
    ])
  end

  defp display_call_result(action, {:ok, activity}) do
    IO.puts("Successful transition to #{activity} with #{action}")
  end

  defp display_call_result(action, {:error, activity}) do
    IO.puts("Cannot transition from #{activity} with #{action}")
  end

  defp ask_for_input(prompt) do
    val = IO.gets(prompt) |> String.trim()
    if String.starts_with?(val, "q"), do: throw(:exit)

    val
  end

  defp select_child_index() do
    ask_for_input("Select child or enter a name to add new: ")
    |> Integer.parse()
    |> elem(0)
  end

  defp select_action_index() do
    ask_for_input("Select a call: ")
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
  end

  defp call_to(pid, action) do
    case action do
      :play -> Child.call_to_play(pid)
      :eat -> Child.call_to_eat(pid)
      :kindergarten -> Child.call_to_kindergarten(pid)
      _ -> IO.puts("Invalid call")
    end
  end
end
