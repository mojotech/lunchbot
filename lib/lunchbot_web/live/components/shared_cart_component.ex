defmodule LunchbotWeb.SharedCartComponent do
  use LunchbotWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="shared-cart">
      <h2>Shared Cart</h2>
      <%= if @office_lunch_orders do %>
        <%= for order <- @office_lunch_orders do %>
          <LunchbotWeb.OrderComponent.display_order order={order} />
          <button phx-click="delete-order"
                phx-value-id={order.id}
                phx-target={@myself}>
            Delete
          </button>
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("delete-order", _params, socket) do
    IO.puts("Handle event. Delete order")
    # %{"id" => id} params
    {:noreply, socket}
  end
end
