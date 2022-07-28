defmodule LunchbotWeb.SharedCart do
  @moduledoc false

  use LunchbotWeb, :live_view

  import LunchbotWeb.SharedCart.SharedCartController
  alias LunchbotWeb.SharedCart.OfficeSelector
  alias LunchbotWeb.SharedCart.OfficeSelectorInterfaceContext
  alias Lunchbot.LunchbotData

  def mount(_params, _session, socket) do
    if connected?(socket), do: Lunchbot.LunchbotData.OrderItem.subscribe()

    default_office_id = 1

    {:ok,
     assign(socket,
       office_lunch_orders: get_lunch_order_for_office(default_office_id),
       offices: LunchbotData.list_offices(),
       selected_office_id: default_office_id
     )
     |> assign_office()
     |> assign_changeset()}
  end

  def assign_office(socket) do
    socket
    |> assign(:office_selector, %OfficeSelector{})
  end

  def assign_changeset(%{assigns: %{office_selector: office_selector}} = socket) do
    socket
    |> assign(:changeset, OfficeSelectorInterfaceContext.change_office(office_selector))
  end

  # Refetch currently displayed order data, assign to socket watched by this LiveView
  defp fetch(socket) do
    office_lunch_orders = get_lunch_order_for_office(socket.assigns.selected_office_id)

    offices = LunchbotData.list_offices()

    assign(socket, office_lunch_orders: office_lunch_orders, offices: offices)
  end

  # listens to the notifications broadcast by OrderItems
  # fetches a fresh listing of office lunch orders from the database
  def handle_info({Lunchbot.LunchbotData.OrderItem, [:order_item, _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  # handles office changes
  def handle_event("change-office", %{"office_selector" => selector_params}, socket) do
    {:noreply,
     assign(socket,
       office_lunch_orders: get_lunch_order_for_office(selector_params["office_selection"]),
       selected_office_id: selector_params["office_selection"]
     )}
  end
end
