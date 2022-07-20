defmodule LunchbotWeb.UserOrdersView do
  use LunchbotWeb, :view

  def table(assigns) do
    ~H"""
    <table>
      <tr>
        <%= for col <- @col do %>
          <th><%= col.label %></th>
        <% end %>
      </tr>
      <%= for row <- @rows do %>
        <tr>
          <%= for col <- @col do %>
            <td><%= render_slot(col, row) %></td>
          <% end %>
        </tr>
      <% end %>
    </table>
    """
  end
end
