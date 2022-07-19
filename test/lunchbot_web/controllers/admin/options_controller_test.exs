defmodule LunchbotWeb.Admin.OptionsControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{
    extra_price: 42,
    extras: true,
    is_required: true,
    name: "some name",
    option_heading_id: 42,
    preselected: true,
    price: 42
  }
  @update_attrs %{
    extra_price: 43,
    extras: false,
    is_required: false,
    name: "some updated name",
    option_heading_id: 43,
    preselected: false,
    price: 43
  }
  @invalid_attrs %{
    extra_price: nil,
    extras: nil,
    is_required: nil,
    name: nil,
    option_heading_id: nil,
    preselected: nil,
    price: nil
  }

  def fixture(:options) do
    {:ok, options} = LunchbotData.create_options(@create_attrs)
    options
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all options", %{conn: conn} do
      conn = get(conn, Routes.admin_options_path(conn, :index))
      assert html_response(conn, 200) =~ "Options"
    end
  end

  describe "new options" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_options_path(conn, :new))
      assert html_response(conn, 200) =~ "New Options"
    end
  end

  describe "create options" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_options_path(conn, :create), options: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_options_path(conn, :show, id)

      conn = get(conn, Routes.admin_options_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Options Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_options_path(conn, :create), options: @invalid_attrs
      assert html_response(conn, 200) =~ "New Options"
    end
  end

  describe "edit options" do
    setup [:create_options]

    test "renders form for editing chosen options", %{conn: conn, options: options} do
      conn = get(conn, Routes.admin_options_path(conn, :edit, options))
      assert html_response(conn, 200) =~ "Edit Options"
    end
  end

  describe "update options" do
    setup [:create_options]

    test "redirects when data is valid", %{conn: conn, options: options} do
      conn = put conn, Routes.admin_options_path(conn, :update, options), options: @update_attrs
      assert redirected_to(conn) == Routes.admin_options_path(conn, :show, options)

      conn = get(conn, Routes.admin_options_path(conn, :show, options))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, options: options} do
      conn = put conn, Routes.admin_options_path(conn, :update, options), options: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Options"
    end
  end

  describe "delete options" do
    setup [:create_options]

    test "deletes chosen options", %{conn: conn, options: options} do
      conn = delete(conn, Routes.admin_options_path(conn, :delete, options))
      assert redirected_to(conn) == Routes.admin_options_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_options_path(conn, :show, options))
      end
    end
  end

  defp create_options(_) do
    options = fixture(:options)
    {:ok, options: options}
  end
end
