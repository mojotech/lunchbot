defmodule LunchbotWeb.OrderComponent do
  @moduledoc false

  use Phoenix.Component

  alias Lunchbot.LunchbotData.OrderItem

  # Visual representation of an "Order".
  # Required field:
  #   order = Lunchbot.LunchbotData.Order
  def display_order(assigns) do
    ~H"""
    <div>
      <b><%= assigns.order.user.name %>'s Order </b> <br>
      Placed @ <em><%= assigns.order.updated_at %></em>
      <ul>
        <%= for order_item <- assigns.order.order_items do %>
            <li><%= order_item.item.name %>
              <%= if !Enum.empty?(order_item.order_item_options) do %>
                (
                <%= for order_item_option <- order_item.order_item_options do %>
                  <%= order_item_option.option.name %>
                <% end %>
                )
              <% end %>
              <%= if !is_nil(OrderItem.get_total(order_item)) do %>
                for <em>$<%= OrderItem.get_total(order_item) %></em>
              <% end %>
            </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
