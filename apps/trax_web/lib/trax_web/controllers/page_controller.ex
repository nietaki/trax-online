defmodule TraxWeb.PageController do
  use TraxWeb, :controller

  def index(conn, _params) do
    message = Trax.message_from_main_app()
    render conn, "index.html", message: message
  end
end
