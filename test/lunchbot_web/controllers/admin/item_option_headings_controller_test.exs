defmodule LunchbotWeb.Admin.ItemOptionHeadingsControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{item_id: 42, option_heading_id: 42}
  @update_attrs %{item_id: 43, option_heading_id: 43}
  @invalid_attrs %{item_id: nil, option_heading_id: nil}

  def fixture(:item_option_headings) do
    {:ok, item_option_headings} = LunchbotData.create_item_option_headings(@create_attrs)
    item_option_headings
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all item_option_headings", %{conn: conn} do
      conn = get(conn, Routes.admin_item_option_headings_path(conn, :index))
      assert html_response(conn, 200) =~ "Item option headings"
    end
  end

  describe "new item_option_headings" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_item_option_headings_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item option headings"
    end
  end

  describe "create item_option_headings" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_item_option_headings_path(conn, :create),
          item_option_headings: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_item_option_headings_path(conn, :show, id)

      conn = get(conn, Routes.admin_item_option_headings_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Item option headings Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_item_option_headings_path(conn, :create),
          item_option_headings: @invalid_attrs

      assert html_response(conn, 200) =~ "New Item option headings"
    end
  end

  describe "edit item_option_headings" do
    setup [:create_item_option_headings]

    test "renders form for editing chosen item_option_headings", %{
      conn: conn,
      item_option_headings: item_option_headings
    } do
      conn = get(conn, Routes.admin_item_option_headings_path(conn, :edit, item_option_headings))
      assert html_response(conn, 200) =~ "Edit Item option headings"
    end
  end

  describe "update item_option_headings" do
    setup [:create_item_option_headings]

    test "redirects when data is valid", %{conn: conn, item_option_headings: item_option_headings} do
      conn =
        put conn, Routes.admin_item_option_headings_path(conn, :update, item_option_headings),
          item_option_headings: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_item_option_headings_path(conn, :show, item_option_headings)

      conn = get(conn, Routes.admin_item_option_headings_path(conn, :show, item_option_headings))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      item_option_headings: item_option_headings
    } do
      conn =
        put conn, Routes.admin_item_option_headings_path(conn, :update, item_option_headings),
          item_option_headings: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Item option headings"
    end
  end

  describe "delete item_option_headings" do
    setup [:create_item_option_headings]

    test "deletes chosen item_option_headings", %{
      conn: conn,
      item_option_headings: item_option_headings
    } do
      conn =
        delete(conn, Routes.admin_item_option_headings_path(conn, :delete, item_option_headings))

      assert redirected_to(conn) == Routes.admin_item_option_headings_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_item_option_headings_path(conn, :show, item_option_headings))
      end
    end
  end

  defp create_item_option_headings(_) do
    item_option_headings = fixture(:item_option_headings)
    {:ok, item_option_headings: item_option_headings}
  end
end
