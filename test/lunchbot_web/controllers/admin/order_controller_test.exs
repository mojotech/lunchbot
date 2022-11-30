defmodule LunchbotWeb.Admin.OrderControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotDataFixtures
  alias Inspect.Lunchbot
  alias LunchbotDataFixtures

  @invalid_attrs %{office_lunch_order_id: nil, menu_id: nil, user_id: nil}

  def fixture(:order) do
    {:ok, order} = LunchbotDataFixtures.order_fixture()
    order
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get(conn, Routes.admin_order_path(conn, :index))
      assert html_response(conn, 200) =~ "Orders"
    end
  end

  describe "new order" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_order_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "create order" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = LunchbotDataFixtures.user_fixture()
      menu = LunchbotDataFixtures.menu_fixture()
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture(%{menu_id: menu.id})

      params = %{
        office_lunch_order_id: office_lunch_order.id,
        menu_id: menu.id,
        user_id: user.id
      }

      conn = post conn, Routes.admin_order_path(conn, :create), order: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_order_path(conn, :show, id)

      conn = get(conn, Routes.admin_order_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Order Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_order_path(conn, :create), order: @invalid_attrs
      assert html_response(conn, 200) =~ "New Order"
    end
  end

  describe "edit order" do
    setup [:create_order]

    test "renders form for editing chosen order", %{conn: conn, order: order} do
      conn = get(conn, Routes.admin_order_path(conn, :edit, order))
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "update order" do
    setup [:create_order]

    test "redirects when data is valid", %{conn: conn, order: order} do
      user = LunchbotDataFixtures.user_fixture()
      menu = LunchbotDataFixtures.menu_fixture()
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture(%{menu_id: menu.id})

      params = %{
        office_lunch_order_id: office_lunch_order.id,
        menu_id: menu.id,
        user_id: user.id
      }

      conn = put conn, Routes.admin_order_path(conn, :update, order), order: params
      assert redirected_to(conn) == Routes.admin_order_path(conn, :show, order)

      conn = get(conn, Routes.admin_order_path(conn, :show, order))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order: order} do
      conn = put conn, Routes.admin_order_path(conn, :update, order), order: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Order"
    end
  end

  describe "delete order" do
    setup [:create_order]

    test "deletes chosen order", %{conn: conn, order: order} do
      conn = delete(conn, Routes.admin_order_path(conn, :delete, order))
      assert redirected_to(conn) == Routes.admin_order_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_order_path(conn, :show, order))
      end
    end
  end

  defp create_order(_) do
    order = LunchbotDataFixtures.order_fixture()
    {:ok, order: order}
  end
end
