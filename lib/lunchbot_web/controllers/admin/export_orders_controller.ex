defmodule LunchbotWeb.Admin.ExportOrdersController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData

  def index(conn, _params) do
    orders = LunchbotData.format_orders(LunchbotData.list_preloaded_orders())

    if !is_nil(orders) do
      list_orders =
        Enum.map(orders, fn x ->
          x |> Enum.map(fn g -> g |> to_string() end) |> Enum.join(", ")
        end)

      render(conn, "index.html", orders: list_orders)
    else
      render(conn, "index.html", orders: nil)
    end
  end

  def export(conn, _params) do
    orders = LunchbotData.format_orders(LunchbotData.list_preloaded_orders())

    conn =
      conn
      |> assign(:orders, orders)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"Exported Orders.csv\"")
    |> send_resp(200, csv_content(conn.assigns.orders))
  end

  defp csv_content(data) do
    data
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end
end
