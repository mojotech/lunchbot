defmodule LunchbotWeb.Admin.OfficeLunchOrderControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{day: ~D[2022-07-07], office_id: 42}
  @update_attrs %{day: ~D[2022-07-08], office_id: 43}
  @invalid_attrs %{day: nil, office_id: nil}

  def fixture(:office_lunch_order) do
    {:ok, office_lunch_order} = LunchbotData.create_office_lunch_order(@create_attrs)
    office_lunch_order
  end

  setup do
    initialize_user()
  end

  describe "index" do
    test "lists all office_lunch_orders", %{conn: conn} do
      conn = get(conn, Routes.admin_office_lunch_order_path(conn, :index))
      assert html_response(conn, 200) =~ "Office lunch orders"
    end
  end

  describe "new office_lunch_order" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_office_lunch_order_path(conn, :new))
      assert html_response(conn, 200) =~ "New Office lunch order"
    end
  end

  describe "create office_lunch_order" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_office_lunch_order_path(conn, :create),
          office_lunch_order: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_office_lunch_order_path(conn, :show, id)

      conn = get(conn, Routes.admin_office_lunch_order_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Office lunch order Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_office_lunch_order_path(conn, :create),
          office_lunch_order: @invalid_attrs

      assert html_response(conn, 200) =~ "New Office lunch order"
    end
  end

  describe "edit office_lunch_order" do
    setup [:create_office_lunch_order]

    test "renders form for editing chosen office_lunch_order", %{
      conn: conn,
      office_lunch_order: office_lunch_order
    } do
      conn = get(conn, Routes.admin_office_lunch_order_path(conn, :edit, office_lunch_order))
      assert html_response(conn, 200) =~ "Edit Office lunch order"
    end
  end

  describe "update office_lunch_order" do
    setup [:create_office_lunch_order]

    test "redirects when data is valid", %{conn: conn, office_lunch_order: office_lunch_order} do
      conn =
        put conn, Routes.admin_office_lunch_order_path(conn, :update, office_lunch_order),
          office_lunch_order: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_office_lunch_order_path(conn, :show, office_lunch_order)

      conn = get(conn, Routes.admin_office_lunch_order_path(conn, :show, office_lunch_order))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      office_lunch_order: office_lunch_order
    } do
      conn =
        put conn, Routes.admin_office_lunch_order_path(conn, :update, office_lunch_order),
          office_lunch_order: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Office lunch order"
    end
  end

  describe "delete office_lunch_order" do
    setup [:create_office_lunch_order]

    test "deletes chosen office_lunch_order", %{
      conn: conn,
      office_lunch_order: office_lunch_order
    } do
      conn = delete(conn, Routes.admin_office_lunch_order_path(conn, :delete, office_lunch_order))
      assert redirected_to(conn) == Routes.admin_office_lunch_order_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_office_lunch_order_path(conn, :show, office_lunch_order))
      end
    end
  end

  defp create_office_lunch_order(_) do
    office_lunch_order = fixture(:office_lunch_order)
    {:ok, office_lunch_order: office_lunch_order}
  end
end
