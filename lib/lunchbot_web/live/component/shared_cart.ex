defmodule LunchbotWeb.SharedCart do
  @moduledoc false

  use Phoenix.Component

  import Lunchbot.Repo
  import Ecto.Query
  alias Lunchbot.LunchbotData.Office
  alias Lunchbot.LunchbotData.OfficeLunchOrder

  # TODO: Update when DB updates
  # TODO: exclude orders from current user, or at least mark them with an id/class/etc for styling purposes.
  def display(assigns) do
    # TODO: avoid calling get_lunch_order_for_office() x2
    ~H"""
    <div id="shared-cart">
      <h2>Shared Cart</h2>
      <%= if get_lunch_order_for_office() do %>
        <%= for order <- get_lunch_order_for_office() do %>
          <LunchbotWeb.OrderComponent.display_order order={order} />
        <% end %>
      <% end %>
    </div>
    """
  end

  def get_lunch_order_for_office(office \\ "Providence", date \\ Date.utc_today()) do
    filter_lunch_orders_to_today_only =
      Ecto.Query.from(o in OfficeLunchOrder, where: o.day == ^date)

    foo =
      Lunchbot.Repo.get_by(Office, name: office)
      |> Lunchbot.Repo.preload(
        office_lunch_orders:
          {filter_lunch_orders_to_today_only,
           [
             orders: [:menu, order_items: [:item, order_item_options: [:option]]]
           ]}
      )
      |> IO.inspect(label: "foobars...")

    if is_nil(Enum.at(foo.office_lunch_orders, 0)) do
      nil
    else
      Enum.at(foo.office_lunch_orders, 0).orders |> IO.inspect(label: "orders...")
    end
  end
end
