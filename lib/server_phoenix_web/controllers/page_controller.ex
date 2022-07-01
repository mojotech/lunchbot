defmodule ServerPhoenixWeb.PageController do
  use ServerPhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
