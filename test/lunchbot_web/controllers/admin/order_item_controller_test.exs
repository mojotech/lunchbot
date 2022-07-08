defmodule LunchbotWeb.Admin.OrderItemControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{item_id: 42, order_id: 42}
  @update_attrs %{item_id: 43, order_id: 43}
  @invalid_attrs %{item_id: nil, order_id: nil}

  def fixture(:order_item) do
    {:ok, order_item} = LunchbotData.create_order_item(@create_attrs)
    order_item
  end

  describe "index" do
    test "lists all order_items", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_path(conn, :index))
      assert html_response(conn, 200) =~ "Order items"
    end
  end

  describe "new order_item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order item"
    end
  end

  describe "create order_item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_order_item_path(conn, :create), order_item: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_order_item_path(conn, :show, id)

      conn = get(conn, Routes.admin_order_item_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Order item Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_order_item_path(conn, :create), order_item: @invalid_attrs
      assert html_response(conn, 200) =~ "New Order item"
    end
  end

  describe "edit order_item" do
    setup [:create_order_item]

    test "renders form for editing chosen order_item", %{conn: conn, order_item: order_item} do
      conn = get(conn, Routes.admin_order_item_path(conn, :edit, order_item))
      assert html_response(conn, 200) =~ "Edit Order item"
    end
  end

  describe "update order_item" do
    setup [:create_order_item]

    test "redirects when data is valid", %{conn: conn, order_item: order_item} do
      conn =
        put conn, Routes.admin_order_item_path(conn, :update, order_item),
          order_item: @update_attrs

      assert redirected_to(conn) == Routes.admin_order_item_path(conn, :show, order_item)

      conn = get(conn, Routes.admin_order_item_path(conn, :show, order_item))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order_item: order_item} do
      conn =
        put conn, Routes.admin_order_item_path(conn, :update, order_item),
          order_item: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Order item"
    end
  end

  describe "delete order_item" do
    setup [:create_order_item]

    test "deletes chosen order_item", %{conn: conn, order_item: order_item} do
      conn = delete(conn, Routes.admin_order_item_path(conn, :delete, order_item))
      assert redirected_to(conn) == Routes.admin_order_item_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_order_item_path(conn, :show, order_item))
      end
    end
  end

  defp create_order_item(_) do
    order_item = fixture(:order_item)
    {:ok, order_item: order_item}
  end
end
