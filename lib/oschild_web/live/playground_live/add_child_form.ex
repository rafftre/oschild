defmodule OschildWeb.PlaygroundLive.AddChildForm do
  use OschildWeb, :live_component

  alias Oschild.Child

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Introduce a new child to the playground.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="add-child-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Introducing...">Introduce</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{child: child} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Child.change_child(child), as: "child", id: "child")
     end)}
  end

  @impl true
  def handle_event("validate", %{"child" => child_params}, socket) do
    changeset = Child.change_child(socket.assigns.child, child_params)

    {:noreply,
     assign(socket, form: to_form(changeset, as: "child", id: "child", action: :validate))}
  end

  def handle_event("save", %{"child" => child_params}, socket) do
    changeset = Child.change_child(socket.assigns.child, child_params)

    case Ecto.Changeset.apply_action(changeset, :update) do
      {:ok, child} ->
        Child.get(child.name)
        notify_parent({:child_added, child.name})

        {:noreply,
         socket
         |> put_flash(:info, "#{child.name} entered the playground")
         |> push_patch(to: socket.assigns.patch)}

      {:error, _} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "child", id: "child"))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
