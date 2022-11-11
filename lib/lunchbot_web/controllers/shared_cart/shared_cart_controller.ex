defmodule LunchbotWeb.SharedCart.SharedCartController do
  import Ecto.Query

  def get_lunch_order_for_office(office_id \\ 1, date \\ Date.utc_today()) do
    filter_lunch_orders_to_today_and_onwards =
      from(olo in Lunchbot.LunchbotData.OfficeLunchOrder,
        where: olo.day >= ^date
      )

    orders_sorted_query =
      from(o in Lunchbot.LunchbotData.Order,
        order_by: [desc: o.updated_at]
      )

    lunch_orders =
      Lunchbot.Repo.get_by(Lunchbot.LunchbotData.Office, id: office_id)
      |> Lunchbot.Repo.preload(
        office_lunch_orders:
          {filter_lunch_orders_to_today_and_onwards,
           [
             orders:
               {orders_sorted_query,
                [:user, :menu, order_items: [:item, order_item_options: [:option]]]}
           ]}
      )

    if is_nil(Enum.at(lunch_orders.office_lunch_orders, 0)) do
      nil
    else
      Enum.at(lunch_orders.office_lunch_orders, 0).orders
    end
  end
end
