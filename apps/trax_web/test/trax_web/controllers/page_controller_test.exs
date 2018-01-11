defmodule TraxWeb.PageControllerTest do
  use TraxWeb.ConnCase

  test "/ redirects to a game index", %{conn: conn} do
    conn = get conn, "/"
    assert "/game/" <> _ = redirected_to(conn)
  end
end
