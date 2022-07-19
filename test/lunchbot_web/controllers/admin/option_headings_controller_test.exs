defmodule LunchbotWeb.Admin.OptionHeadingsControllerTest do
  use LunchbotWeb.ConnCase

  alias Lunchbot.LunchbotData

  @create_attrs %{name: "some name", priority: 42}
  @update_attrs %{name: "some updated name", priority: 43}
  @invalid_attrs %{name: nil, priority: nil}

  def fixture(:option_headings) do
    {:ok, option_headings} = LunchbotData.create_option_headings(@create_attrs)
    option_headings
  end

  setup do
    initialize_admin_user()
  end

  describe "index" do
    test "lists all option_headings", %{conn: conn} do
      conn = get(conn, Routes.admin_option_headings_path(conn, :index))
      assert html_response(conn, 200) =~ "Option headings"
    end
  end

  describe "new option_headings" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_option_headings_path(conn, :new))
      assert html_response(conn, 200) =~ "New Option headings"
    end
  end

  describe "create option_headings" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_option_headings_path(conn, :create),
          option_headings: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_option_headings_path(conn, :show, id)

      conn = get(conn, Routes.admin_option_headings_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Option headings Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post conn, Routes.admin_option_headings_path(conn, :create),
          option_headings: @invalid_attrs

      assert html_response(conn, 200) =~ "New Option headings"
    end
  end

  describe "edit option_headings" do
    setup [:create_option_headings]

    test "renders form for editing chosen option_headings", %{
      conn: conn,
      option_headings: option_headings
    } do
      conn = get(conn, Routes.admin_option_headings_path(conn, :edit, option_headings))
      assert html_response(conn, 200) =~ "Edit Option headings"
    end
  end

  describe "update option_headings" do
    setup [:create_option_headings]

    test "redirects when data is valid", %{conn: conn, option_headings: option_headings} do
      conn =
        put conn, Routes.admin_option_headings_path(conn, :update, option_headings),
          option_headings: @update_attrs

      assert redirected_to(conn) ==
               Routes.admin_option_headings_path(conn, :show, option_headings)

      conn = get(conn, Routes.admin_option_headings_path(conn, :show, option_headings))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, option_headings: option_headings} do
      conn =
        put conn, Routes.admin_option_headings_path(conn, :update, option_headings),
          option_headings: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Option headings"
    end
  end

  describe "delete option_headings" do
    setup [:create_option_headings]

    test "deletes chosen option_headings", %{conn: conn, option_headings: option_headings} do
      conn = delete(conn, Routes.admin_option_headings_path(conn, :delete, option_headings))
      assert redirected_to(conn) == Routes.admin_option_headings_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_option_headings_path(conn, :show, option_headings))
      end
    end
  end

  defp create_option_headings(_) do
    option_headings = fixture(:option_headings)
    {:ok, option_headings: option_headings}
  end
end
