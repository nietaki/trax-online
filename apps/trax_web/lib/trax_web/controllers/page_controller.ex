defmodule TraxWeb.PageController do
  use TraxWeb, :controller
  alias TraxWeb.GameId

  def index(conn, _params) do
    game_id = GameId.generate()
    game_path = TraxWeb.Router.Helpers.page_path(conn, :game_index, game_id)
    redirect conn, to: game_path
  end

  def game_index(conn, %{"id" => id}) do
    render conn, "index.html", message: id
  end
end
