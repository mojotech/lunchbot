defmodule LunchbotWeb.Admin.OfficeLunchOrderController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OfficeLunchOrder

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_office_lunch_orders(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(
          :error,
          "There was an error rendering Office lunch orders. #{inspect(error)}"
        )
        |> redirect(to: Routes.admin_office_lunch_order_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_office_lunch_order(%OfficeLunchOrder{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"office_lunch_order" => office_lunch_order_params}) do
    case LunchbotData.create_office_lunch_order(office_lunch_order_params) do
      {:ok, office_lunch_order} ->
        conn
        |> put_flash(:info, "Office lunch order created successfully.")
        |> redirect(to: Routes.admin_office_lunch_order_path(conn, :show, office_lunch_order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    office_lunch_order = LunchbotData.get_office_lunch_order!(id)
    render(conn, "show.html", office_lunch_order: office_lunch_order)
  end

  def edit(conn, %{"id" => id}) do
    office_lunch_order = LunchbotData.get_office_lunch_order!(id)
    changeset = LunchbotData.change_office_lunch_order(office_lunch_order)
    render(conn, "edit.html", office_lunch_order: office_lunch_order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "office_lunch_order" => office_lunch_order_params}) do
    office_lunch_order = LunchbotData.get_office_lunch_order!(id)

    case LunchbotData.update_office_lunch_order(office_lunch_order, office_lunch_order_params) do
      {:ok, office_lunch_order} ->
        conn
        |> put_flash(:info, "Office lunch order updated successfully.")
        |> redirect(to: Routes.admin_office_lunch_order_path(conn, :show, office_lunch_order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", office_lunch_order: office_lunch_order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    office_lunch_order = LunchbotData.get_office_lunch_order!(id)
    {:ok, _office_lunch_order} = LunchbotData.delete_office_lunch_order(office_lunch_order)

    conn
    |> put_flash(:info, "Office lunch order deleted successfully.")
    |> redirect(to: Routes.admin_office_lunch_order_path(conn, :index))
  end
end
