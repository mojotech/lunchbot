defmodule LunchbotWeb.Admin.OrderItemExtraControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{extra_id: 42, order_item_id: 42}
  @update_attrs %{extra_id: 43, order_item_id: 43}
  @invalid_attrs %{extra_id: nil, order_item_id: nil}

  def fixture(:order_item_extra) do
    {:ok, order_item_extra} = LunchbotData.create_order_item_extra(@create_attrs)
    order_item_extra
  end

  describe "index" do
    test "lists all order_item_extras", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_extra_path(conn, :index))
      assert html_response(conn, 200) =~ "Order item extras"
    end
  end

  describe "new order_item_extra" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_order_item_extra_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order item extra"
    end
  end

  describe "create order_item_extra" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_order_item_extra_path(conn, :create),
          order_item_extra: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_order_item_extra_path(conn, :show, id)

      conn = get(conn, Routes.admin_order_item_extra_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Order item extra Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_order_item_extra_path(conn, :create),
          order_item_extra: @invalid_attrs

      assert html_response(conn, 200) =~ "New Order item extra"
    end
  end

  describe "edit order_item_extra" do
    setup [:create_order_item_extra]

    test "renders form for editing chosen order_item_extra", %{
      conn: conn,
      order_item_extra: order_item_extra
    } do
      conn = get(conn, Routes.admin_order_item_extra_path(conn, :edit, order_item_extra))
      assert html_response(conn, 200) =~ "Edit Order item extra"
    end
  end

  describe "update order_item_extra" do
    setup [:create_order_item_extra]

    test "redirects when data is valid", %{conn: conn, order_item_extra: order_item_extra} do
      conn =
        put conn, Routes.admin_order_item_extra_path(conn, :update, order_item_extra),
          order_item_extra: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_order_item_extra_path(conn, :show, order_item_extra)

      conn = get(conn, Routes.admin_order_item_extra_path(conn, :show, order_item_extra))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, order_item_extra: order_item_extra} do
      conn =
        put conn, Routes.admin_order_item_extra_path(conn, :update, order_item_extra),
          order_item_extra: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Order item extra"
    end
  end

  describe "delete order_item_extra" do
    setup [:create_order_item_extra]

    test "deletes chosen order_item_extra", %{conn: conn, order_item_extra: order_item_extra} do
      conn = delete(conn, Routes.admin_order_item_extra_path(conn, :delete, order_item_extra))
      assert redirected_to(conn) == Routes.admin_order_item_extra_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_order_item_extra_path(conn, :show, order_item_extra))
      end
    end
  end

  defp create_order_item_extra(_) do
    order_item_extra = fixture(:order_item_extra)
    {:ok, order_item_extra: order_item_extra}
  end
end
