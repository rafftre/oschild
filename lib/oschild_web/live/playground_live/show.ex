defmodule OschildWeb.PlaygroundLive.Show do
  use OschildWeb, :live_view

  alias Oschild.Child.Core, as: ChildCore
  alias OschildWeb.PlaygroundLive.AddChildForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_children(socket)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({AddChildForm, {:child_added, _}}, socket) do
    {:noreply, assign_children(socket)}
  end

  defp apply_action(socket, :add, _params) do
    socket
    |> assign(:page_title, "Introduce a Child")
    |> assign(:child, %ChildCore{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Playground")
    |> assign(:child, nil)
  end

  defp assign_children(socket) do
    children =
      Oschild.Child.all()
      |> Enum.filter(fn x -> is_pid(x) end)
      |> Enum.map(fn x -> ptos(x) end)

    assign(socket, :children, children)
  end

  defp ptos(pid) when is_pid(pid) do
    list = :erlang.pid_to_list(pid)
    list |> List.delete_at(0) |> List.delete_at(-1) |> to_string()
  end

  defp ptos(_pid), do: ""
end
