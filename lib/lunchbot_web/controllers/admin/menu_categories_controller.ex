defmodule LunchbotWeb.Admin.MenuCategoriesController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.MenuCategories

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_menu_categories(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Menu categories. #{inspect(error)}")
        |> redirect(to: Routes.admin_menu_categories_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_menu_categories(%MenuCategories{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"menu_categories" => menu_categories_params}) do
    case LunchbotData.create_menu_categories(menu_categories_params) do
      {:ok, menu_categories} ->
        conn
        |> put_flash(:info, "Menu categories created successfully.")
        |> redirect(to: Routes.admin_menu_categories_path(conn, :show, menu_categories))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    menu_categories = LunchbotData.get_menu_categories!(id)
    render(conn, "show.html", menu_categories: menu_categories)
  end

  def edit(conn, %{"id" => id}) do
    menu_categories = LunchbotData.get_menu_categories!(id)
    changeset = LunchbotData.change_menu_categories(menu_categories)
    render(conn, "edit.html", menu_categories: menu_categories, changeset: changeset)
  end

  def update(conn, %{"id" => id, "menu_categories" => menu_categories_params}) do
    menu_categories = LunchbotData.get_menu_categories!(id)

    case LunchbotData.update_menu_categories(menu_categories, menu_categories_params) do
      {:ok, menu_categories} ->
        conn
        |> put_flash(:info, "Menu categories updated successfully.")
        |> redirect(to: Routes.admin_menu_categories_path(conn, :show, menu_categories))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", menu_categories: menu_categories, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    menu_categories = LunchbotData.get_menu_categories!(id)
    {:ok, _menu_categories} = LunchbotData.delete_menu_categories(menu_categories)

    conn
    |> put_flash(:info, "Menu categories deleted successfully.")
    |> redirect(to: Routes.admin_menu_categories_path(conn, :index))
  end
end
