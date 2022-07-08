defmodule LunchbotWeb.Admin.OfficeController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.Office

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_offices(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Offices. #{inspect(error)}")
        |> redirect(to: Routes.admin_office_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_office(%Office{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"office" => office_params}) do
    case LunchbotData.create_office(office_params) do
      {:ok, office} ->
        conn
        |> put_flash(:info, "Office created successfully.")
        |> redirect(to: Routes.admin_office_path(conn, :show, office))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    office = LunchbotData.get_office!(id)
    render(conn, "show.html", office: office)
  end

  def edit(conn, %{"id" => id}) do
    office = LunchbotData.get_office!(id)
    changeset = LunchbotData.change_office(office)
    render(conn, "edit.html", office: office, changeset: changeset)
  end

  def update(conn, %{"id" => id, "office" => office_params}) do
    office = LunchbotData.get_office!(id)

    case LunchbotData.update_office(office, office_params) do
      {:ok, office} ->
        conn
        |> put_flash(:info, "Office updated successfully.")
        |> redirect(to: Routes.admin_office_path(conn, :show, office))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", office: office, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    office = LunchbotData.get_office!(id)
    {:ok, _office} = LunchbotData.delete_office(office)

    conn
    |> put_flash(:info, "Office deleted successfully.")
    |> redirect(to: Routes.admin_office_path(conn, :index))
  end
end
