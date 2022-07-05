defmodule LunchbotWeb.AuthController do
  @moduledoc """
  This AuthController is responsible for handling all of
  Ueberauth's responses. We are authenticating logins and storing
  auth information
  """
  use LunchbotWeb, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers
  alias Lunchbot.Accounts
  alias LunchbotWeb.Auth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(
        %{assigns: %{ueberauth_auth: auth}} = conn,
        %{"provider" => "google", "hd" => "mojotech.com"} = _params
      ) do
    with {:ok, user} <- UserFromAuth.find_or_create(auth),
         {:ok, user} <- Accounts.get_or_create_user(user) do
      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> Auth.put_current_user(user)
      |> redirect(to: "/")
    else
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def callback(
        %{assigns: %{ueberauth_auth: _auth}} = conn,
        %{"provider" => "google", "hd" => _not_mojotech} = _params
      ) do
    conn
    |> put_flash(:error, "Must log in with a MojoTech account.")
    |> redirect(to: "/")
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end
end
