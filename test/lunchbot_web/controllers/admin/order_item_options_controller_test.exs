defmodule LunchbotWeb.Admin.OrderItemOptionsControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotDataFixtures

  @invalid_attrs %{option_id: nil, order_item_id: nil}

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all order_item_options", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_options_path(conn, :index))
      assert html_response(conn, 200) =~ "Order item options"
    end
  end

  describe "new order_item_options" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_options_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order item options"
    end
  end

  describe "create order_item_options" do
    test "redirects to show when data is valid", %{conn: conn} do
      #   @create_attrs %{option_id: 42, order_item_id: 42}
      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()

      params = %{
        option_id: option.id,
        order_item_id: order_item.id
      }

      conn =
        post conn, Routes.admin_order_item_options_path(conn, :create), order_item_options: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_order_item_options_path(conn, :show, id)

      conn = get(conn, Routes.admin_order_item_options_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Order item options Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_order_item_options_path(conn, :create),
          order_item_options: @invalid_attrs

      assert html_response(conn, 200) =~ "New Order item options"
    end
  end

  describe "edit order_item_options" do
    setup [:create_order_item_options]

    test "renders form for editing chosen order_item_options", %{
      conn: conn,
      order_item_options: order_item_options
    } do
      conn = get(conn, Routes.admin_order_item_options_path(conn, :edit, order_item_options))
      assert html_response(conn, 200) =~ "Edit Order item options"
    end
  end

  describe "update order_item_options" do
    setup [:create_order_item_options]

    test "redirects when data is valid", %{conn: conn, order_item_options: order_item_options} do
      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()

      params = %{
        option_id: option.id,
        order_item_id: order_item.id
      }

      conn =
        put conn, Routes.admin_order_item_options_path(conn, :update, order_item_options),
          order_item_options: params

      assert redirected_to(conn) ==
               Routes.admin_order_item_options_path(conn, :show, order_item_options)

      conn = get(conn, Routes.admin_order_item_options_path(conn, :show, order_item_options))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      order_item_options: order_item_options
    } do
      conn =
        put conn, Routes.admin_order_item_options_path(conn, :update, order_item_options),
          order_item_options: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Order item options"
    end
  end

  describe "delete order_item_options" do
    setup [:create_order_item_options]

    test "deletes chosen order_item_options", %{
      conn: conn,
      order_item_options: order_item_options
    } do
      conn = delete(conn, Routes.admin_order_item_options_path(conn, :delete, order_item_options))
      assert redirected_to(conn) == Routes.admin_order_item_options_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_order_item_options_path(conn, :show, order_item_options))
      end
    end
  end

  defp create_order_item_options(_) do
    order_item_options = LunchbotDataFixtures.order_item_options_fixture()
    {:ok, order_item_options: order_item_options}
  end
end
