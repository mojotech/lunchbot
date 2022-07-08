defmodule LunchbotWeb.Admin.ExtraController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.Extra

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_extras(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Extras. #{inspect(error)}")
        |> redirect(to: Routes.admin_extra_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_extra(%Extra{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"extra" => extra_params}) do
    case LunchbotData.create_extra(extra_params) do
      {:ok, extra} ->
        conn
        |> put_flash(:info, "Extra created successfully.")
        |> redirect(to: Routes.admin_extra_path(conn, :show, extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    extra = LunchbotData.get_extra!(id)
    render(conn, "show.html", extra: extra)
  end

  def edit(conn, %{"id" => id}) do
    extra = LunchbotData.get_extra!(id)
    changeset = LunchbotData.change_extra(extra)
    render(conn, "edit.html", extra: extra, changeset: changeset)
  end

  def update(conn, %{"id" => id, "extra" => extra_params}) do
    extra = LunchbotData.get_extra!(id)

    case LunchbotData.update_extra(extra, extra_params) do
      {:ok, extra} ->
        conn
        |> put_flash(:info, "Extra updated successfully.")
        |> redirect(to: Routes.admin_extra_path(conn, :show, extra))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", extra: extra, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    extra = LunchbotData.get_extra!(id)
    {:ok, _extra} = LunchbotData.delete_extra(extra)

    conn
    |> put_flash(:info, "Extra deleted successfully.")
    |> redirect(to: Routes.admin_extra_path(conn, :index))
  end
end
