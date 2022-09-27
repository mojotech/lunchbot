defmodule LunchbotWeb.Admin.SelectMenuLive do
  use LunchbotWeb, :live_view

  alias Lunchbot.LunchbotData
  alias Lunchbot.LunchbotData.OfficeLunchOrder

  def mount(_params, _session, socket) do
    changeset = LunchbotData.change_office_lunch_order(%OfficeLunchOrder{})
    menus = LunchbotData.list_menu_name_id_tuples()
    offices = LunchbotData.list_office_name_id_tuples()

    socket =
      assign(socket,
        changeset: changeset,
        offices: offices,
        menus: menus
      )

    {:ok, socket}
  end

  def handle_event("save", %{"office_lunch_order" => olo_params}, socket) do
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
      {:ok, office_lunch_order} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  defp to_naive_datetime(<<yyyy::binary-4, mm::binary-2, dd::binary-2>>) do
    [yyyy, mm, dd] = for i <- [yyyy, mm, dd], do: String.to_integer(i)
    NaiveDateTime.new!(yyyy, mm, dd, 0, 0, 0)
  end
end
