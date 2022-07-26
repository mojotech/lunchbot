defmodule LunchbotWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Lunchbot.Accounts

  # TODO:
  #   https://blog.appsignal.com/2022/01/25/securing-your-phoenix-liveview-apps.html
  #   & https://stackoverflow.com/questions/66217782/elixir-phoenix-liveview-passing-user-id-through-socket
  def on_mount(:user, _params, %{"user_token" => user_token} = _session, socket) do
    socket = assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
