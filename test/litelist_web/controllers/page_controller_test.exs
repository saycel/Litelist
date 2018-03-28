defmodule LitelistWeb.PageControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  setup do
    username = "page controller user"
    correct_password = "password"
    incorrect_password = ""
    neighbor = Factory.insert(:neighbor, %{username: username})

    {:ok, neighbor: neighbor, username: username, correct_password: correct_password, incorrect_password: incorrect_password}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ "Othernet"
  end

  test "GET /information", %{conn: conn} do
    conn = get conn, page_path(conn, :information)
    assert html_response(conn, 200) =~ "about othernet list"
  end

  describe "login" do

    test "GET /login", %{conn: conn} do
      conn = get conn, page_path(conn, :login)
      assert html_response(conn, 200) =~ "Sign in"
    end

    test "GET /login when already signed in", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(page_path(conn, :login))

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "POST / :login with correct credentials", %{conn: conn, username: username, correct_password: correct_password} do
    credentials = %{username: username, password: correct_password} 
      conn = conn
        |> post(page_path(conn, :post_login), neighbor: credentials)

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "POST / :login with incorrect credentials", %{conn: conn, username: username, incorrect_password: incorrect_password} do
      credentials = %{username: username, password: incorrect_password} 
        conn = conn
          |> post(page_path(conn, :index), neighbor: credentials)
  
        assert redirected_to(conn) == page_path(conn, :login)
      end
  end

  test "logout", %{conn: conn, neighbor: neighbor} do
    conn = conn
      |> login_neighbor(neighbor)
      |> post(page_path(conn, :logout))

    assert redirected_to(conn) == "/"
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
