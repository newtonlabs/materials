defmodule MaterialsWeb.PageControllerTest do
  use MaterialsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Dishes"
  end
end
