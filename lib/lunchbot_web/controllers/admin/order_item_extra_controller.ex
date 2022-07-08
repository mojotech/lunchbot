defmodule LunchbotWeb.Admin.OrderItemExtraController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OrderItemExtra

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_order_item_extras(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Order item extras. #{inspect(error)}")
        |> redirect(to: Routes.admin_order_item_extra_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_order_item_extra(%OrderItemExtra{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order_item_extra" => order_item_extra_params}) do
    case LunchbotData.create_order_item_extra(order_item_extra_params) do
      {:ok, order_item_extra} ->
        conn
        |> put_flash(:info, "Order item extra created successfully.")
        |> redirect(to: Routes.admin_order_item_extra_path(conn, :show, order_item_extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order_item_extra = LunchbotData.get_order_item_extra!(id)
    render(conn, "show.html", order_item_extra: order_item_extra)
  end

  def edit(conn, %{"id" => id}) do
    order_item_extra = LunchbotData.get_order_item_extra!(id)
    changeset = LunchbotData.change_order_item_extra(order_item_extra)
    render(conn, "edit.html", order_item_extra: order_item_extra, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order_item_extra" => order_item_extra_params}) do
    order_item_extra = LunchbotData.get_order_item_extra!(id)

    case LunchbotData.update_order_item_extra(order_item_extra, order_item_extra_params) do
      {:ok, order_item_extra} ->
        conn
        |> put_flash(:info, "Order item extra updated successfully.")
        |> redirect(to: Routes.admin_order_item_extra_path(conn, :show, order_item_extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order_item_extra: order_item_extra, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item_extra = LunchbotData.get_order_item_extra!(id)
    {:ok, _order_item_extra} = LunchbotData.delete_order_item_extra(order_item_extra)

    conn
    |> put_flash(:info, "Order item extra deleted successfully.")
    |> redirect(to: Routes.admin_order_item_extra_path(conn, :index))
  end
end
