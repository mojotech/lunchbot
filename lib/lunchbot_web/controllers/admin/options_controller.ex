defmodule LunchbotWeb.Admin.OptionsController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.Options

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_options(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Options. #{inspect(error)}")
        |> redirect(to: Routes.admin_options_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_options(%Options{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"options" => options_params}) do
    case LunchbotData.create_options(options_params) do
      {:ok, options} ->
        conn
        |> put_flash(:info, "Options created successfully.")
        |> redirect(to: Routes.admin_options_path(conn, :show, options))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    options = LunchbotData.get_options!(id)
    render(conn, "show.html", options: options)
  end

  def edit(conn, %{"id" => id}) do
    options = LunchbotData.get_options!(id)
    changeset = LunchbotData.change_options(options)
    render(conn, "edit.html", options: options, changeset: changeset)
  end

  def update(conn, %{"id" => id, "options" => options_params}) do
    options = LunchbotData.get_options!(id)

    case LunchbotData.update_options(options, options_params) do
      {:ok, options} ->
        conn
        |> put_flash(:info, "Options updated successfully.")
        |> redirect(to: Routes.admin_options_path(conn, :show, options))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", options: options, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    options = LunchbotData.get_options!(id)
    {:ok, _options} = LunchbotData.delete_options(options)

    conn
    |> put_flash(:info, "Options deleted successfully.")
    |> redirect(to: Routes.admin_options_path(conn, :index))
  end
end
