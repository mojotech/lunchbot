defmodule LunchbotWeb.GoogleAuthController do
  use LunchbotWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)

    if(profile.email =~ "@mojotech.com") do
      conn
      |> put_view(LunchbotWeb.PageView)
      |> render("index.html", current_user: profile)
    else
      conn
      |> put_flash(:error, "Must log in with a MojoTech account.")
      |> redirect(to: "/")
    end
  end
end
