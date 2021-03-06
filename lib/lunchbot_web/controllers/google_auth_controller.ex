defmodule LunchbotWeb.GoogleAuthController do
  use LunchbotWeb, :controller

  alias Lunchbot.Accounts
  alias LunchbotWeb.UserAuth

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)

    if(profile.email =~ "@mojotech.com") do
      user_params = %{name: profile.name, email: profile.email}

      case Accounts.fetch_or_create_user(user_params) do
        {:ok, user} ->
          UserAuth.log_in_user(conn, user)

        _ ->
          conn
          |> put_flash(:error, "Authentication failed")
          |> redirect(to: "/")
      end
    else
      conn
      |> put_flash(:error, "Must log in with a MojoTech account.")
      |> redirect(to: "/")
    end
  end
end
