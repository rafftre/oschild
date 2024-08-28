defmodule OschildWeb.ChildComponents do
  use Phoenix.Component

  def heading(assigns) do
    ~H"""
    <div class="mb-2 flex items-center gap-3">
      <h5 class="mb-2 font-sans text-2xl font-semibold leading-snug tracking-normal text-blue-gray-900 antialiased">
        <%= @child.name %>
      </h5>

      <div
        class={[
          "center relative inline-block select-none whitespace-nowrap rounded-full py-1 px-2",
          "align-baseline font-sans text-xs font-medium capitalize leading-none tracking-wide text-white",
          class_for_activity(@child.activity)
        ]}
      >
        <div class="mt-px"><%= @child.activity %></div>
      </div>
    </div>
    """
  end

  def mood(assigns) do
    ~H"""
    <div class="flex items-center gap-1">
      <OschildWeb.CoreComponents.icon
        name={icon_for_mood(@value)}
        class={[
          "h-5 w-5",
          class_for_mood(@value)
        ]} />
      <p class="block font-sans text-base font-normal text-gray-700 antialiased">
        Mood is <%= @value %>
      </p>
    </div>
    """
  end

  def snacks(assigns) do
    ~H"""
    <div class="flex items-center gap-1">
      <OschildWeb.CoreComponents.icon name="hero-cake" class="h-5 w-5 text-blue-500" />

      <p class="block font-sans text-base font-normal text-gray-700 antialiased">
        Has <%= @amount %>
        <%= if @amount != 1 do %>
          snacks
        <% else %>
          snack
        <% end %>
      </p>

      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def action(assigns) do
    ~H"""
    <button
      class={[
        "flex select-none items-center gap-2 rounded-lg py-2 px-4 text-center align-middle",
        "font-sans text-xs font-bold uppercase text-pink-500",
        "transition-all bg-white hover:bg-pink-500/10 active:bg-pink-500/30",
        "disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def class_for_activity(:playing), do: "bg-blue-500"
  def class_for_activity(:eating), do: "bg-fuchsia-500"
  def class_for_activity(_), do: "bg-stone-500"

  def icon_for_mood(mood) when mood <= 0, do: "hero-face-frown"
  def icon_for_mood(_), do: "hero-face-smile"

  def class_for_mood(mood) when mood <= 0, do: "text-yellow-500"
  def class_for_mood(_), do: "text-emerald-400"
end
