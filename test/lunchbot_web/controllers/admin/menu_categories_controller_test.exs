defmodule LunchbotWeb.Admin.MenuCategoriesControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{category_id: 42, menu_id: 42}
  @update_attrs %{category_id: 43, menu_id: 43}
  @invalid_attrs %{category_id: nil, menu_id: nil}

  def fixture(:menu_categories) do
    {:ok, menu_categories} = LunchbotData.create_menu_categories(@create_attrs)
    menu_categories
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all menu_categories", %{conn: conn} do
      conn = get(conn, Routes.admin_menu_categories_path(conn, :index))
      assert html_response(conn, 200) =~ "Menu categories"
    end
  end

  describe "new menu_categories" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_menu_categories_path(conn, :new))
      assert html_response(conn, 200) =~ "New Menu categories"
    end
  end

  describe "create menu_categories" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_menu_categories_path(conn, :create),
          menu_categories: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_menu_categories_path(conn, :show, id)

      conn = get(conn, Routes.admin_menu_categories_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Menu categories Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_menu_categories_path(conn, :create),
          menu_categories: @invalid_attrs

      assert html_response(conn, 200) =~ "New Menu categories"
    end
  end

  describe "edit menu_categories" do
    setup [:create_menu_categories]

    test "renders form for editing chosen menu_categories", %{
      conn: conn,
      menu_categories: menu_categories
    } do
      conn = get(conn, Routes.admin_menu_categories_path(conn, :edit, menu_categories))
      assert html_response(conn, 200) =~ "Edit Menu categories"
    end
  end

  describe "update menu_categories" do
    setup [:create_menu_categories]

    test "redirects when data is valid", %{conn: conn, menu_categories: menu_categories} do
      conn =
        put conn, Routes.admin_menu_categories_path(conn, :update, menu_categories),
          menu_categories: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_menu_categories_path(conn, :show, menu_categories)

      conn = get(conn, Routes.admin_menu_categories_path(conn, :show, menu_categories))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, menu_categories: menu_categories} do
      conn =
        put conn, Routes.admin_menu_categories_path(conn, :update, menu_categories),
          menu_categories: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Menu categories"
    end
  end

  describe "delete menu_categories" do
    setup [:create_menu_categories]

    test "deletes chosen menu_categories", %{conn: conn, menu_categories: menu_categories} do
      conn = delete(conn, Routes.admin_menu_categories_path(conn, :delete, menu_categories))
      assert redirected_to(conn) == Routes.admin_menu_categories_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_menu_categories_path(conn, :show, menu_categories))
      end
    end
  end

  defp create_menu_categories(_) do
    menu_categories = fixture(:menu_categories)
    {:ok, menu_categories: menu_categories}
  end
end
