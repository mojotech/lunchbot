defmodule LunchbotWeb.Admin.OrderItemOptionsController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OrderItemOptions

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_order_item_options(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Order item options. #{inspect(error)}")
        |> redirect(to: Routes.admin_order_item_options_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_order_item_options(%OrderItemOptions{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order_item_options" => order_item_options_params}) do
    case LunchbotData.create_order_item_options(order_item_options_params) do
      {:ok, order_item_options} ->
        conn
        |> put_flash(:info, "Order item options created successfully.")
        |> redirect(to: Routes.admin_order_item_options_path(conn, :show, order_item_options))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order_item_options = LunchbotData.get_order_item_options!(id)
    render(conn, "show.html", order_item_options: order_item_options)
  end

  def edit(conn, %{"id" => id}) do
    order_item_options = LunchbotData.get_order_item_options!(id)
    changeset = LunchbotData.change_order_item_options(order_item_options)
    render(conn, "edit.html", order_item_options: order_item_options, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order_item_options" => order_item_options_params}) do
    order_item_options = LunchbotData.get_order_item_options!(id)

    case LunchbotData.update_order_item_options(order_item_options, order_item_options_params) do
      {:ok, order_item_options} ->
        conn
        |> put_flash(:info, "Order item options updated successfully.")
        |> redirect(to: Routes.admin_order_item_options_path(conn, :show, order_item_options))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order_item_options: order_item_options, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order_item_options = LunchbotData.get_order_item_options!(id)
    {:ok, _order_item_options} = LunchbotData.delete_order_item_options(order_item_options)

    conn
    |> put_flash(:info, "Order item options deleted successfully.")
    |> redirect(to: Routes.admin_order_item_options_path(conn, :index))
  end
end
