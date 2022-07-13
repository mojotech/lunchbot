defmodule LunchbotWeb.Admin.ItemExtraControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{extra_id: 42, item_id: 42}
  @update_attrs %{extra_id: 43, item_id: 43}
  @invalid_attrs %{extra_id: nil, item_id: nil}

  def fixture(:item_extra) do
    {:ok, item_extra} = LunchbotData.create_item_extra(@create_attrs)
    item_extra
  end

  describe "index" do
    test "lists all item_extras", %{conn: conn} do
      conn = get(conn, Routes.admin_item_extra_path(conn, :index))
      assert html_response(conn, 200) =~ "Item extras"
    end
  end

  describe "new item_extra" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_item_extra_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item extra"
    end
  end

  describe "create item_extra" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_item_extra_path(conn, :create), item_extra: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_item_extra_path(conn, :show, id)

      conn = get(conn, Routes.admin_item_extra_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Item extra Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_item_extra_path(conn, :create), item_extra: @invalid_attrs
      assert html_response(conn, 200) =~ "New Item extra"
    end
  end

  describe "edit item_extra" do
    setup [:create_item_extra]

    test "renders form for editing chosen item_extra", %{conn: conn, item_extra: item_extra} do
      conn = get(conn, Routes.admin_item_extra_path(conn, :edit, item_extra))
      assert html_response(conn, 200) =~ "Edit Item extra"
    end
  end

  describe "update item_extra" do
    setup [:create_item_extra]

    test "redirects when data is valid", %{conn: conn, item_extra: item_extra} do
      conn =
        put conn, Routes.admin_item_extra_path(conn, :update, item_extra),
          item_extra: @update_attrs

      assert redirected_to(conn) == Routes.admin_item_extra_path(conn, :show, item_extra)

      conn = get(conn, Routes.admin_item_extra_path(conn, :show, item_extra))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, item_extra: item_extra} do
      conn =
        put conn, Routes.admin_item_extra_path(conn, :update, item_extra),
          item_extra: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Item extra"
    end
  end

  describe "delete item_extra" do
    setup [:create_item_extra]

    test "deletes chosen item_extra", %{conn: conn, item_extra: item_extra} do
      conn = delete(conn, Routes.admin_item_extra_path(conn, :delete, item_extra))
      assert redirected_to(conn) == Routes.admin_item_extra_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_item_extra_path(conn, :show, item_extra))
      end
    end
  end

  defp create_item_extra(_) do
    item_extra = fixture(:item_extra)
    {:ok, item_extra: item_extra}
  end
end
