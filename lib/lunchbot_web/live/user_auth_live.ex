defmodule LunchbotWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Lunchbot.Accounts

  # Helper for LiveView pages to get the current user.
  # To use, declare "on_mount {LunchbotWeb.UserAuthLive, :user}"
  # and reference in HEEX as "@current_user"
  def on_mount(:user, _params, %{"user_token" => user_token} = _session, socket) do
    socket = assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
