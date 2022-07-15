defmodule LunchbotWeb.Admin.ItemControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{category_id: 42, deleted: true, image_url: "some image_url", name: "some name"}
  @update_attrs %{
    category_id: 43,
    deleted: false,
    image_url: "some updated image_url",
    name: "some updated name"
  }
  @invalid_attrs %{category_id: nil, deleted: nil, image_url: nil, name: nil}

  def fixture(:item) do
    {:ok, item} = LunchbotData.create_item(@create_attrs)
    item
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.admin_item_path(conn, :index))
      assert html_response(conn, 200) =~ "Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_item_path(conn, :create), item: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_item_path(conn, :show, id)

      conn = get(conn, Routes.admin_item_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Item Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_item_path(conn, :create), item: @invalid_attrs
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get(conn, Routes.admin_item_path(conn, :edit, item))
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put conn, Routes.admin_item_path(conn, :update, item), item: @update_attrs
      assert redirected_to(conn) == Routes.admin_item_path(conn, :show, item)

      conn = get(conn, Routes.admin_item_path(conn, :show, item))
      assert html_response(conn, 200) =~ "some updated image_url"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put conn, Routes.admin_item_path(conn, :update, item), item: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, Routes.admin_item_path(conn, :delete, item))
      assert redirected_to(conn) == Routes.admin_item_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_item_path(conn, :show, item))
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
