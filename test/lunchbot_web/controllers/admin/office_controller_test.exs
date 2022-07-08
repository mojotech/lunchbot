defmodule LunchbotWeb.Admin.OfficeControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{timezone: "some timezone"}
  @update_attrs %{timezone: "some updated timezone"}
  @invalid_attrs %{timezone: nil}

  def fixture(:office) do
    {:ok, office} = LunchbotData.create_office(@create_attrs)
    office
  end

  describe "index" do
    test "lists all offices", %{conn: conn} do
      conn = get(conn, Routes.admin_office_path(conn, :index))
      assert html_response(conn, 200) =~ "Offices"
    end
  end

  describe "new office" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_office_path(conn, :new))
      assert html_response(conn, 200) =~ "New Office"
    end
  end

  describe "create office" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_office_path(conn, :create), office: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_office_path(conn, :show, id)

      conn = get(conn, Routes.admin_office_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Office Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_office_path(conn, :create), office: @invalid_attrs
      assert html_response(conn, 200) =~ "New Office"
    end
  end

  describe "edit office" do
    setup [:create_office]

    test "renders form for editing chosen office", %{conn: conn, office: office} do
      conn = get(conn, Routes.admin_office_path(conn, :edit, office))
      assert html_response(conn, 200) =~ "Edit Office"
    end
  end

  describe "update office" do
    setup [:create_office]

    test "redirects when data is valid", %{conn: conn, office: office} do
      conn = put conn, Routes.admin_office_path(conn, :update, office), office: @update_attrs
      assert redirected_to(conn) == Routes.admin_office_path(conn, :show, office)

      conn = get(conn, Routes.admin_office_path(conn, :show, office))
      assert html_response(conn, 200) =~ "some updated timezone"
    end

    test "renders errors when data is invalid", %{conn: conn, office: office} do
      conn = put conn, Routes.admin_office_path(conn, :update, office), office: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Office"
    end
  end

  describe "delete office" do
    setup [:create_office]

    test "deletes chosen office", %{conn: conn, office: office} do
      conn = delete(conn, Routes.admin_office_path(conn, :delete, office))
      assert redirected_to(conn) == Routes.admin_office_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_office_path(conn, :show, office))
      end
    end
  end

  defp create_office(_) do
    office = fixture(:office)
    {:ok, office: office}
  end
end
