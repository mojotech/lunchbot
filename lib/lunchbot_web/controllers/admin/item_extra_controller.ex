defmodule LunchbotWeb.Admin.ItemExtraController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.ItemExtra

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_item_extras(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Item extras. #{inspect(error)}")
        |> redirect(to: Routes.admin_item_extra_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_item_extra(%ItemExtra{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item_extra" => item_extra_params}) do
    case LunchbotData.create_item_extra(item_extra_params) do
      {:ok, item_extra} ->
        conn
        |> put_flash(:info, "Item extra created successfully.")
        |> redirect(to: Routes.admin_item_extra_path(conn, :show, item_extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item_extra = LunchbotData.get_item_extra!(id)
    render(conn, "show.html", item_extra: item_extra)
  end

  def edit(conn, %{"id" => id}) do
    item_extra = LunchbotData.get_item_extra!(id)
    changeset = LunchbotData.change_item_extra(item_extra)
    render(conn, "edit.html", item_extra: item_extra, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item_extra" => item_extra_params}) do
    item_extra = LunchbotData.get_item_extra!(id)

    case LunchbotData.update_item_extra(item_extra, item_extra_params) do
      {:ok, item_extra} ->
        conn
        |> put_flash(:info, "Item extra updated successfully.")
        |> redirect(to: Routes.admin_item_extra_path(conn, :show, item_extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item_extra: item_extra, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_extra = LunchbotData.get_item_extra!(id)
    {:ok, _item_extra} = LunchbotData.delete_item_extra(item_extra)

    conn
    |> put_flash(:info, "Item extra deleted successfully.")
    |> redirect(to: Routes.admin_item_extra_path(conn, :index))
  end
end
