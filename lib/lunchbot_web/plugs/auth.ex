defmodule LunchbotWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias LunchbotWeb.Router.Helpers, as: Routes
  alias Lunchbot.Accounts

  # You can manually add someone to be an admin here
  @site_admins ~w[
    admin_example@mojotech.com
  ]

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      cond do
        assigned = conn.assigns[:current_User] -> assigned
        true -> Accounts.get_user_from_id(user_id)
      end

    put_current_user(conn, user)
  end

  def authenticate_admin(conn = %{assigns: %{admin_user: true}}, _), do: conn

  # For accounts that are not admins + json format
  def authenticate_admin(conn = %{private: %{phoenix_format: "json"}}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> json(%{error: "unauthorized"})
  end

  # For accounts that are not admins + not json format (likely HTML, need to flash)
  def authenticate_admin(conn, _opts) do
    conn
    |> put_flash(:error, "You do not have access to this page")
    |> redirect(to: Routes.page_path(conn, :app))
    |> halt()
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _), do: conn

  def logged_in_user(conn = %{private: %{phoenix_format: "json"}}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> json(%{error: "unauthorized"})
  end

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access this page")
    |> redirect(to: Routes.page_path(conn, :app))
    |> halt()
  end

  def put_current_user(conn, user) do
    token = user && LunchbotWeb.Token.sign(%{id: user.id})

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
    |> assign(
      :admin_user,
      (!!user && user.email) in @site_admins
    )
    |> put_session(:user_id, user && user.id)
    |> configure_session(renew: true)
    |> put_req_header("authorization", "Bearer #{token}")
  end

  def drop_current_user(conn) do
    conn
    |> delete_req_header("authorization")
    |> configure_session(drop: true)
  end
end
