defmodule LunchbotWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use LunchbotWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  import Lunchbot.AccountsFixtures
  import Phoenix.ConnTest
  alias LunchbotWeb.Router.Helpers, as: Routes
  alias Lunchbot.Repo
  alias Lunchbot.Accounts.User

  @endpoint LunchbotWeb.Endpoint

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import LunchbotWeb.ConnCase

      alias LunchbotWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint LunchbotWeb.Endpoint
    end
  end

  setup tags do
    Lunchbot.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Lunchbot.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Lunchbot.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  def initialize_user() do
    unique_int = System.unique_integer()

    user_attrs = %{
      name: "some name",
      email: "email#{unique_int}@mojotech.com",
      role: "some role",
      password: "some password",
      hashed_password: "some hashed password",
      confirmed_at: ~N[2000-01-01 23:00:07]
    }

    user_fixture(user_attrs)

    {:ok,
     %{
       user: user_attrs,
       conn:
         post(build_conn(), Routes.user_session_path(build_conn(), :create), %{
           user: %{
             email: "email#{unique_int}@mojotech.com",
             password: "some password"
           }
         })
     }}
  end

  def initialize_admin_user() do
    # Change the repo first before returning the new user
    {:ok, resp} =
      initialize_user()
      |> put_in([Access.elem(1), :user, :role], "admin")

    Repo.get_by!(User, email: resp.user.email)
    |> User.changeset(resp.user)
    |> Repo.update()

    {:ok, resp}
  end
end
