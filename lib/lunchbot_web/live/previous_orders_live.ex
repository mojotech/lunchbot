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
          <LunchbotWeb.OrderComponent.display_order order={an_order} />
        </ul>
      </li>
    <% end %>
    </ul>
    """
  end
end
