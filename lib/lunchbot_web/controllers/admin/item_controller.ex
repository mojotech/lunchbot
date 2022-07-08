defmodule LunchbotWeb.Admin.ItemController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.Item

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_items(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Items. #{inspect(error)}")
        |> redirect(to: Routes.admin_item_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case LunchbotData.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.admin_item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = LunchbotData.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = LunchbotData.get_item!(id)
    changeset = LunchbotData.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = LunchbotData.get_item!(id)

    case LunchbotData.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.admin_item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = LunchbotData.get_item!(id)
    {:ok, _item} = LunchbotData.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.admin_item_path(conn, :index))
  end
end
