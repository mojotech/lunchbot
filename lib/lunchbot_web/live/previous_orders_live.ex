defmodule LunchbotWeb.PreviousOrdersLive do
  @moduledoc false
  use Phoenix.LiveView, layout: {LunchbotWeb.LayoutView, "live.html"}
  #  use LunchbotWeb, :view

  import Lunchbot.Repo
  import Phoenix.HTML.Link
  alias Lunchbot.Accounts
  alias Lunchbot.LunchbotData.Order
  alias Lunchbot.LunchbotData.OrderItem

  # Initial state for the live view; populates the relevant socket assignments
  def mount(_params, session, socket) do
    %{"user_token" => user_token} = session

    user_with_preloaded_orders =
      Accounts.get_user_by_session_token(user_token)
      |> preload(orders: [:menu, order_items: [:item, order_item_options: [:option]]])

    {:ok,
     assign(socket,
       user: user_with_preloaded_orders,
       show_rating: true,
       show_rating_modifiers: true
     )}
  end

  def handle_event("rating-edit", %{"myvar1" => "@order_item", "myvar2" => "val2"}, socket) do
    IO.inspect("TODO - HANDLE rating-edit EVENT")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Previous Orders for <%= @user.name %>:</h1>
    <ul>
    <%= for an_order <- @user.orders do %>
      <li>ORDER # <%= an_order.id %> || $<%= Order.get_total(an_order) %>
        <ul>
          <div>
            From <b><%= an_order.menu.name %></b> @ <em><%= an_order.inserted_at %></em>
            <ul>
              <%= for order_item <- an_order.order_items do %>
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
                    <%= if Map.has_key?(assigns, :show_rating) do %>
                      <%= if !is_nil(order_item.rating) do %>
                        [Rating: <%= order_item.rating %>/5]
                        <%= if Map.has_key?(assigns, :show_rating_modifiers) do %>
                          (<span phx-click="rating-edit" phx-value-myvar1="@order_item" phx-value-myvar2="val2"><a>Edit Rating</a></span>)
                        <% end %>
                      <% else %>
                        <%= if Map.has_key?(assigns, :show_rating_modifiers) do %>
                          (<%= link "Add Rating", to: "#TODO-ADD-RATING" %>)
                        <% end %>
                      <% end %>
                    <% end %>
                  </li>
              <% end %>
            </ul>
          </div>
        </ul>
      </li>
    <% end %>
    </ul>
    """
  end
end
