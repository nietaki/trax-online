defmodule TraxWeb.PageController do
  use TraxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
