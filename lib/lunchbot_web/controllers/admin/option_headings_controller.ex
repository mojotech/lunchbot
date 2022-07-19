defmodule LunchbotWeb.Admin.OptionHeadingsController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OptionHeadings

  plug(:put_root_layout, {LunchbotWeb.LayoutView, "torch.html"})
  plug(:put_layout, false)

  def index(conn, params) do
    case LunchbotData.paginate_option_headings(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Option headings. #{inspect(error)}")
        |> redirect(to: Routes.admin_option_headings_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = LunchbotData.change_option_headings(%OptionHeadings{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"option_headings" => option_headings_params}) do
    case LunchbotData.create_option_headings(option_headings_params) do
      {:ok, option_headings} ->
        conn
        |> put_flash(:info, "Option headings created successfully.")
        |> redirect(to: Routes.admin_option_headings_path(conn, :show, option_headings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    option_headings = LunchbotData.get_option_headings!(id)
    render(conn, "show.html", option_headings: option_headings)
  end

  def edit(conn, %{"id" => id}) do
    option_headings = LunchbotData.get_option_headings!(id)
    changeset = LunchbotData.change_option_headings(option_headings)
    render(conn, "edit.html", option_headings: option_headings, changeset: changeset)
  end

  def update(conn, %{"id" => id, "option_headings" => option_headings_params}) do
    option_headings = LunchbotData.get_option_headings!(id)

    case LunchbotData.update_option_headings(option_headings, option_headings_params) do
      {:ok, option_headings} ->
        conn
        |> put_flash(:info, "Option headings updated successfully.")
        |> redirect(to: Routes.admin_option_headings_path(conn, :show, option_headings))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", option_headings: option_headings, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    option_headings = LunchbotData.get_option_headings!(id)
    {:ok, _option_headings} = LunchbotData.delete_option_headings(option_headings)

    conn
    |> put_flash(:info, "Option headings deleted successfully.")
    |> redirect(to: Routes.admin_option_headings_path(conn, :index))
  end
end
