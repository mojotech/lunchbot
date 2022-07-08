defmodule LunchbotWeb.Admin.MenuController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.Menu

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_menus(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Menus. #{inspect(error)}")
        |> redirect(to: Routes.admin_menu_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_menu(%Menu{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"menu" => menu_params}) do
    case LunchbotData.create_menu(menu_params) do
      {:ok, menu} ->
        conn
        |> put_flash(:info, "Menu created successfully.")
        |> redirect(to: Routes.admin_menu_path(conn, :show, menu))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    menu = LunchbotData.get_menu!(id)
    render(conn, "show.html", menu: menu)
  end

  def edit(conn, %{"id" => id}) do
    menu = LunchbotData.get_menu!(id)
    changeset = LunchbotData.change_menu(menu)
    render(conn, "edit.html", menu: menu, changeset: changeset)
  end

  def update(conn, %{"id" => id, "menu" => menu_params}) do
    menu = LunchbotData.get_menu!(id)

    case LunchbotData.update_menu(menu, menu_params) do
      {:ok, menu} ->
        conn
        |> put_flash(:info, "Menu updated successfully.")
        |> redirect(to: Routes.admin_menu_path(conn, :show, menu))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", menu: menu, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    menu = LunchbotData.get_menu!(id)
    {:ok, _menu} = LunchbotData.delete_menu(menu)

    conn
    |> put_flash(:info, "Menu deleted successfully.")
    |> redirect(to: Routes.admin_menu_path(conn, :index))
  end
end
