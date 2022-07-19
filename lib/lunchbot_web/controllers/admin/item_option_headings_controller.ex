defmodule LunchbotWeb.Admin.ItemOptionHeadingsController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.ItemOptionHeadings

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_item_option_headings(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(
          :error,
          "There was an error rendering Item option headings. #{inspect(error)}"
        )
        |> redirect(to: Routes.admin_item_option_headings_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_item_option_headings(%ItemOptionHeadings{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item_option_headings" => item_option_headings_params}) do
    case LunchbotData.create_item_option_headings(item_option_headings_params) do
      {:ok, item_option_headings} ->
        conn
        |> put_flash(:info, "Item option headings created successfully.")
        |> redirect(to: Routes.admin_item_option_headings_path(conn, :show, item_option_headings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item_option_headings = LunchbotData.get_item_option_headings!(id)
    render(conn, "show.html", item_option_headings: item_option_headings)
  end

  def edit(conn, %{"id" => id}) do
    item_option_headings = LunchbotData.get_item_option_headings!(id)
    changeset = LunchbotData.change_item_option_headings(item_option_headings)
    render(conn, "edit.html", item_option_headings: item_option_headings, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item_option_headings" => item_option_headings_params}) do
    item_option_headings = LunchbotData.get_item_option_headings!(id)

    case LunchbotData.update_item_option_headings(
           item_option_headings,
           item_option_headings_params
         ) do
      {:ok, item_option_headings} ->
        conn
        |> put_flash(:info, "Item option headings updated successfully.")
        |> redirect(to: Routes.admin_item_option_headings_path(conn, :show, item_option_headings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item_option_headings: item_option_headings, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_option_headings = LunchbotData.get_item_option_headings!(id)
    {:ok, _item_option_headings} = LunchbotData.delete_item_option_headings(item_option_headings)

    conn
    |> put_flash(:info, "Item option headings deleted successfully.")
    |> redirect(to: Routes.admin_item_option_headings_path(conn, :index))
  end
end
