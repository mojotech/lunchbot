defmodule LunchbotWeb.Admin.ExtraControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{item_id: 42, name: "some name"}
  @update_attrs %{item_id: 43, name: "some updated name"}
  @invalid_attrs %{item_id: nil, name: nil}

  def fixture(:extra) do
    {:ok, extra} = LunchbotData.create_extra(@create_attrs)
    extra
  end

  describe "index" do
    test "lists all extras", %{conn: conn} do
      conn = get(conn, Routes.admin_extra_path(conn, :index))
      assert html_response(conn, 200) =~ "Extras"
    end
  end

  describe "new extra" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_extra_path(conn, :new))
      assert html_response(conn, 200) =~ "New Extra"
    end
  end

  describe "create extra" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_extra_path(conn, :create), extra: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_extra_path(conn, :show, id)

      conn = get(conn, Routes.admin_extra_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Extra Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_extra_path(conn, :create), extra: @invalid_attrs
      assert html_response(conn, 200) =~ "New Extra"
    end
  end

  describe "edit extra" do
    setup [:create_extra]

    test "renders form for editing chosen extra", %{conn: conn, extra: extra} do
      conn = get(conn, Routes.admin_extra_path(conn, :edit, extra))
      assert html_response(conn, 200) =~ "Edit Extra"
    end
  end

  describe "update extra" do
    setup [:create_extra]

    test "redirects when data is valid", %{conn: conn, extra: extra} do
      conn = put conn, Routes.admin_extra_path(conn, :update, extra), extra: @update_attrs
      assert redirected_to(conn) == Routes.admin_extra_path(conn, :show, extra)

      conn = get(conn, Routes.admin_extra_path(conn, :show, extra))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, extra: extra} do
      conn = put conn, Routes.admin_extra_path(conn, :update, extra), extra: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Extra"
    end
  end

  describe "delete extra" do
    setup [:create_extra]

    test "deletes chosen extra", %{conn: conn, extra: extra} do
      conn = delete(conn, Routes.admin_extra_path(conn, :delete, extra))
      assert redirected_to(conn) == Routes.admin_extra_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_extra_path(conn, :show, extra))
      end
    end
  end

  defp create_extra(_) do
    extra = fixture(:extra)
    {:ok, extra: extra}
  end
end
