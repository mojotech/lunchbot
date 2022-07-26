defmodule LunchbotWeb.OrderLive do
  use LunchbotWeb, :live_view

  alias LunchbotWeb.Router.Helpers, as: Routes
  alias Lunchbot.Repo
  alias Lunchbot.LunchbotData

  import Ecto.Query

  def mount(_params, _session, socket) do
    # How is this id going to be initialized?
    todays_menu_id = 4

    menu_data =
      Repo.get(Lunchbot.LunchbotData.Menu, todays_menu_id)
      |> Repo.preload(categories: [items: [option_headings: [:options]]])
      |> Map.from_struct()

    {:ok, assign(socket, menu_data: menu_data) |> assign(todays_menu_id: todays_menu_id)}
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
    option_ids_query =
      from o in "options",
        join: m in Lunchbot.LunchbotData.Menu,
        on: m.id == ^socket.assigns.todays_menu_id,
        where: o.name in ^options.selected_options,
        select: o.id

    option_ids = Repo.all(option_ids_query)

    current_user_id = socket.assigns.current_user.id

    # How is this id going to get set?
    office_lunch_order_id = 1

    order_id =
      Repo.insert(%LunchbotData.Order{
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
      Repo.insert(%LunchbotData.OrderItem{
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
