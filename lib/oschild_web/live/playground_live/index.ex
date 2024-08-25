defmodule OschildWeb.PlaygroundLive.Index do
  use OschildWeb, :live_view

  alias Oschild.Child.Core, as: ChildCore
  alias OschildWeb.PlaygroundLive.AddChild
  alias OschildWeb.PlaygroundLive.ShowChild

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_child_servers(socket)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({AddChild, {:child_added, _}}, socket) do
    {:noreply, assign_child_servers(socket)}
  end

  def handle_info({ShowChild, {:call_failed, msg}}, socket) do
    {:noreply, put_flash(socket, :error, msg)}
  end

  defp apply_action(socket, :add, _params) do
    socket
    |> assign(:page_title, "Introduce a Child")
    |> assign(:child, %ChildCore{})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Child Playground")
    |> assign(:child, nil)
  end

  defp assign_child_servers(socket) do
    child_servers =
      Oschild.Child.all()
      |> Enum.filter(fn x -> is_pid(x) end)
      |> Enum.map(fn x -> {x, to_s(x)} end)

    assign(socket, :child_servers, child_servers)
  end

  def to_s(server) when is_pid(server) do
    list = :erlang.pid_to_list(server)
    list |> List.delete_at(0) |> List.delete_at(-1) |> to_string()
  end

  def to_s(_), do: ""
end
