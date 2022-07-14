defmodule LunchbotWeb.Admin.UserControllerTest do
  use LunchbotWeb.ConnCase, async: true

  import Lunchbot.AccountsFixtures

  @unique_attrs %{
    name: "some name",
    email: "email#{System.unique_integer()}@mojotech.com",
    role: "admin",
    password: "some password",
    hashed_password: "some hashed password",
    confirmed_at: ~N[2000-01-01 23:00:07]
  }
  @update_attrs %{
    name: "some updated name",
    email: "updated_email@mojotech.com",
    role: "admin",
    password: "some updated password",
    hashed_password: "some updated hashed password",
    confirmed_at: ~N[2001-01-01 23:00:07]
  }
  @invalid_attrs %{name: nil, email: nil, role: nil}

  setup do
    %{user: user_fixture(@unique_attrs)}
  end

  setup do
    %{
      conn:
        post(build_conn(), Routes.user_session_path(build_conn(), :create), %{
          "user" => %{"email" => @unique_attrs.email, "password" => @unique_attrs.password}
        })
    }
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200) =~ "Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post conn, Routes.admin_user_path(conn, :create),
          user: %{
            name: "some name",
            email: "unique#{System.unique_integer()}@mojotech.com",
            password: "some_password",
            role: "admin",
            confirmed_at: ~N[2000-01-01 23:00:07]
          }

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, id)

      conn = get(conn, Routes.admin_user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "User Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, Routes.admin_user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == Routes.admin_user_path(conn, :show, user)

      conn = get(conn, Routes.admin_user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "updated_email@mojotech.com"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, Routes.admin_user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_user_path(conn, :show, user))
      end
    end
  end
end
