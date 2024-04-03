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

    res = call_to(elem(child, 0), action)
    display_call_result(child, action, res)

    interact()
  end

  defp display_playground(children) do
    IO.puts([
      "Playground is ",
      children
      |> Enum.with_index()
      |> Enum.map(fn {{_pid, x}, i} -> "#{i}: #{Atom.to_string(x)}" end)
      |> Enum.join(", ")
    ])
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

  defp display_call_result({_pid, prev}, action, {:ok, next}) do
    IO.puts("Successful transition from #{prev} to #{next} with #{action}")
  end

  defp display_call_result({_pid, prev}, action, {:error, _}) do
    IO.puts("Cannot transition from #{prev} with #{action}")
  end

  defp ask_for_input(prompt) do
    val = IO.gets(prompt) |> String.trim()
    if String.starts_with?(val, "q"), do: throw(:exit)

    val
  end

  defp select_child_index() do
    ask_for_input("Select child: ")
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
