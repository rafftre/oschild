defmodule OschildWeb.Playground do
  use OschildWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Playground")
     |> assign_children()}
  end

  def assign_children(socket) do
    children =
      Oschild.Child.all()
      |> Enum.filter(fn x -> is_pid(x) end)
      |> Enum.map(fn x -> ptos(x) end)

    socket
    |> assign(:children, children)
  end

  defp ptos(pid) when is_pid(pid) do
    list = :erlang.pid_to_list(pid)
    list |> List.delete_at(0) |> List.delete_at(-1) |> to_string()
  end

  defp ptos(_pid), do: ""
end
