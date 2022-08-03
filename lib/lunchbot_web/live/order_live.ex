defmodule LunchbotWeb.OrderLive do
  use LunchbotWeb, :live_view

  alias LunchbotWeb.Router.Helpers, as: Routes
  alias Lunchbot.LunchbotData

  def mount(_params, _session, socket) do
    socket = assign(socket, offices: Lunchbot.LunchbotData.list_offices())

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :show, _params) do
    assign(socket, show_modal: false)
  end

  def apply_action(%{assigns: %{show_modal: _}} = socket, :open_modal, params) do
    assign(socket, show_modal: true, id: Integer.parse(params["id"]) |> elem(0))
  end

  def apply_action(socket, _live_action, _params) do
    push_patch(socket,
      to: Routes.create_order_path(socket, :show),
      replace: true
    )
  end

  def handle_event(
        "office_select",
        %{"office_id" => %{"office" => office_id_string}} = _args,
        socket
      ) do
    office_id = Integer.parse(office_id_string) |> elem(0)

    olo_ids = LunchbotData.get_office_lunch_order_ids(office_id)

    socket =
      if(olo_ids != nil) do
        menu_data = LunchbotData.get_all_menu_data(olo_ids |> Enum.at(1))

        socket
        |> assign(menu_data: menu_data)
        |> assign(office_lunch_order_id: olo_ids |> Enum.at(0))
        |> assign(todays_menu_id: olo_ids |> Enum.at(1))
      else
        socket |> assign(office_id: office_id)
      end

    {:noreply, socket}
  end

  def handle_event("open", %{"id" => id} = _args, socket) do
    {:noreply,
     push_patch(
       assign(socket, show_modal: true),
       to: Routes.create_order_modal_path(socket, :open_modal, id: id),
       replace: true
     )}
  end

  def handle_info(
        {LunchbotWeb.LiveComponent.ModalLive, :button_clicked,
         %{action: "submit", param: options}},
        socket
      ) do
    option_ids =
      LunchbotData.get_selected_options(socket.assigns.todays_menu_id, options.selected_options)

    current_user_id = socket.assigns.current_user.id

    office_lunch_order_id = socket.assigns.office_lunch_order_id

    order_id =
      LunchbotData.create_order(%{
        user_id: current_user_id,
        menu_id: socket.assigns.todays_menu_id,
        lunch_order_id: office_lunch_order_id
      })
      |> case do
        {:ok, %LunchbotData.Order{id: id}} ->
          id

        {:error, reason} ->
          {:error, reason}
      end

    order_item_id =
      LunchbotData.create_order_item(%{
        item_id: elem(Integer.parse(options.id), 0),
        order_id: order_id
      })
      |> case do
        {:ok, %LunchbotData.OrderItem{id: id}} ->
          id

        {:error, reason} ->
          {:error, reason}
      end

    for option_id <- option_ids do
      LunchbotData.create_order_item_options(%{option_id: option_id, order_item_id: order_item_id})
    end

    socket =
      socket
      |> assign(show_modal: false)
      |> assign(id: nil)

    {:noreply, socket}
  end

  def handle_info(
        {LunchbotWeb.LiveComponent.ModalLive, :button_clicked, %{action: "close"}},
        socket
      ) do
    socket =
      socket
      |> assign(show_modal: false)
      |> assign(id: nil)

    {:noreply,
     push_patch(
       socket,
       to: Routes.create_order_path(socket, :show),
       replace: true
     )}
  end
end
