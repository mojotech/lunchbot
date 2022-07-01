defmodule LunchbotWeb.PageController do
  use LunchbotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
