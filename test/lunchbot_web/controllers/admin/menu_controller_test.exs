defmodule LunchbotWeb.Admin.MenuControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{name: "some name", office_id: 42}
  @update_attrs %{name: "some updated name", office_id: 43}
  @invalid_attrs %{name: nil, office_id: nil}

  def fixture(:menu) do
    {:ok, menu} = LunchbotData.create_menu(@create_attrs)
    menu
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all menus", %{conn: conn} do
      conn = get(conn, Routes.admin_menu_path(conn, :index))
      assert html_response(conn, 200) =~ "Menus"
    end
  end

  describe "new menu" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_menu_path(conn, :new))
      assert html_response(conn, 200) =~ "New Menu"
    end
  end

  describe "create menu" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_menu_path(conn, :create), menu: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_menu_path(conn, :show, id)

      conn = get(conn, Routes.admin_menu_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Menu Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_menu_path(conn, :create), menu: @invalid_attrs
      assert html_response(conn, 200) =~ "New Menu"
    end
  end

  describe "edit menu" do
    setup [:create_menu]

    test "renders form for editing chosen menu", %{conn: conn, menu: menu} do
      conn = get(conn, Routes.admin_menu_path(conn, :edit, menu))
      assert html_response(conn, 200) =~ "Edit Menu"
    end
  end

  describe "update menu" do
    setup [:create_menu]

    test "redirects when data is valid", %{conn: conn, menu: menu} do
      conn = put conn, Routes.admin_menu_path(conn, :update, menu), menu: @update_attrs
      assert redirected_to(conn) == Routes.admin_menu_path(conn, :show, menu)

      conn = get(conn, Routes.admin_menu_path(conn, :show, menu))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, menu: menu} do
      conn = put conn, Routes.admin_menu_path(conn, :update, menu), menu: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Menu"
    end
  end

  describe "delete menu" do
    setup [:create_menu]

    test "deletes chosen menu", %{conn: conn, menu: menu} do
      conn = delete(conn, Routes.admin_menu_path(conn, :delete, menu))
      assert redirected_to(conn) == Routes.admin_menu_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_menu_path(conn, :show, menu))
      end
    end
  end

  defp create_menu(_) do
    menu = fixture(:menu)
    {:ok, menu: menu}
  end
end
