defmodule OschildWeb.PlaygroundLive.ShowChild do
  use OschildWeb, :live_component

  alias Oschild.Child

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_child()}
  end

  @impl true
  def handle_event("play" = event, _params, socket),
    do: handle_action(event, &Child.call_to_play/1, socket)

  def handle_event("eat" = event, _params, socket),
    do: handle_action(event, &Child.call_to_eat/1, socket)

  def handle_event("kindergarten" = event, _params, socket),
    do: handle_action(event, &Child.call_to_kindergarten/1, socket)

  def handle_event("snack" = event, _params, socket),
    do: handle_action(event, &Child.give_snack/1, socket)

  def handle_action(action, child_fn, %{assigns: %{child_server: server}} = socket) do
    IO.inspect(child_fn)

    {:noreply,
     server
     |> child_fn.()
     |> handle_transition(action, socket)}
  end

  defp handle_transition({:ok, _}, _action, socket), do: assign_child(socket)

  defp handle_transition({:error, _}, "snack", socket) do
    notify_parent({:call_failed, "Snacks may be given only while playing or eating"})
    socket
  end

  defp handle_transition({:error, activity}, action, %{assigns: %{child: child}} = socket) do
    notify_parent(
      {:call_failed, "#{child.name} cannot answer the call to #{action} while #{activity}"}
    )

    socket
  end

  defp assign_child(%{assigns: %{child_server: server}} = socket) do
    assign(socket, :child, Child.get_state(server))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
