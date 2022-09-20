defmodule LunchbotWeb.Admin.SelectMenuController do
  use LunchbotWeb, :controller

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OfficeLunchOrder

  def index(conn, _params) do
    changeset = OfficeLunchOrder.changeset(%OfficeLunchOrder{}, %{})

    menus = LunchbotData.list_menu_name_id_tuples()
    offices = LunchbotData.list_office_name_id_tuples()

    render(conn, "view.html", changeset: changeset, menus: menus, offices: offices)
  end

  def create(conn, %{"office_lunch_order" => olo_params}) do
    date = olo_params["date"]

    formatted_date =
      to_naive_datetime(
        date["year"] <>
          if(String.length(date["month"]) == 1) do
            "0" <> date["month"]
          else
            date["month"]
          end <>
          if(String.length(date["day"]) == 1) do
            "0" <> date["day"]
          else
            date["day"]
          end
      )

    new_office_lunch_order = %{
      day: formatted_date,
      office_id: olo_params["office_id"],
      menu_id: olo_params["menu_id"]
    }

    case LunchbotData.create_office_lunch_order(new_office_lunch_order) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Office lunch order created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "view.html",
          changeset: changeset,
          menus: LunchbotData.list_menu_name_id_tuples()
        )
    end
  end

  defp to_naive_datetime(<<yyyy::binary-4, mm::binary-2, dd::binary-2>>) do
    [yyyy, mm, dd] = for i <- [yyyy, mm, dd], do: String.to_integer(i)
    NaiveDateTime.new!(yyyy, mm, dd, 0, 0, 0)
  end
end
