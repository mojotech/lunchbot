defmodule LunchbotWeb.PreviousOrdersLive do
  @moduledoc false
  use Phoenix.LiveView, layout: {LunchbotWeb.LayoutView, "live.html"}

  import Lunchbot.Repo
  alias Lunchbot.Accounts
  alias Lunchbot.LunchbotData.Order

  # Initial state for the live view; populates the relevant socket assignments
  def mount(_params, session, socket) do
    %{"user_token" => user_token} = session

    user_with_preloaded_orders =
      Accounts.get_user_by_session_token(user_token)
      |> preload(orders: [:menu, order_items: [:item, order_item_options: [:option]]])

    {:ok, assign(socket, user: user_with_preloaded_orders)}
  end

  def render(assigns) do
    ~H"""
    <h1>Previous Orders for <%= @user.name %>:</h1>
    <ul>
    <%= for an_order <- @user.orders do %>
      <li>ORDER # <%= an_order.id %> || $<%= Order.get_total(an_order) %>
        <ul>
          <li>From the <%= an_order.menu.name %> Menu</li>
          <li>Date Ordered: <%= an_order.inserted_at %></li>
          <li>Items in order:
            <ul>
              <%= for an_order_item <- an_order.order_items do %>
                  <li><%= an_order_item.item.name %>
                    <%= if !Enum.empty?(an_order_item.order_item_options) do %>
                      (w/ options:
                      <%= for an_order_item_option <- an_order_item.order_item_options do %>
                        <%= an_order_item_option.option.name %>
                      <% end %>
                      )
                    <% end %>
                  </li>
              <% end %>
            </ul>
          </li>
        </ul>
      </li>
    <% end %>
    </ul>
    """
  end
end
