defmodule Litelist.NeighborControllerTest do
    use LitelistWeb.ConnCase

    test "GET /neighbor/new", %{conn: conn} do
        conn = get conn, "/neighbor/new"
        assert html_response(conn, 200) =~ "User Signup"
    end

    test "GET /neighbor/:id", %{conn: conn} do
        conn = get conn, "/neighbor/1"
        assert html_response(conn, 200)
    end

    test "POST /neighbor", %{conn: conn} do
        conn = post conn, "/neighbor"
        assert html_response(conn, 200)
    end
end