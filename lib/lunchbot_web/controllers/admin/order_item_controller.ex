defmodule LunchbotWeb.Admin.OrderItemController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OrderItem

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_order_items(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Order items. #{inspect(error)}")
        |> redirect(to: Routes.admin_order_item_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_order_item(%OrderItem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order_item" => order_item_params}) do
    case LunchbotData.create_order_item(order_item_params) do
      {:ok, order_item} ->
        conn
        |> put_flash(:info, "Order item created successfully.")
        |> redirect(to: Routes.admin_order_item_path(conn, :show, order_item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order_item = LunchbotData.get_order_item!(id)
    render(conn, "show.html", order_item: order_item)
  end

  def edit(conn, %{"id" => id}) do
    order_item = LunchbotData.get_order_item!(id)
    changeset = LunchbotData.change_order_item(order_item)
    render(conn, "edit.html", order_item: order_item, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    order_item = LunchbotData.get_order_item!(id)
    {:ok, _order_item} = LunchbotData.delete_order_item(order_item)

    conn
    |> put_flash(:info, "Order item deleted successfully.")
    |> redirect(to: Routes.admin_order_item_path(conn, :index))
  end
end
