defmodule LitelistWeb.PageControllerTest do
  use LitelistWeb.ConnCase, async: true
  import Phoenix.Controller

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  alias LitelistWeb.Router.Helpers, as: Routes

  setup do
    username = "page controller user"
    correct_password = "password"
    incorrect_password = ""
    neighbor = Factory.insert(:neighbor, %{username: username})

    {:ok, neighbor: neighbor, username: username, correct_password: correct_password, incorrect_password: incorrect_password}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, Routes.page_path(conn, :index)
    assert html_response(conn, 200)
    assert view_template(conn) == "index.html"
  end

  test "GET /information", %{conn: conn} do
    conn = get conn, Routes.page_path(conn, :information)
    assert html_response(conn, 200)
    assert view_template(conn) == "post2list.html"
  end

  describe "login" do

    test "GET /login", %{conn: conn} do
      conn = get conn, Routes.page_path(conn, :login)
      assert view_template(conn) == "login.html"
    end

    test "GET /login when already signed in", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(Routes.page_path(conn, :login))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "POST / :login with correct credentials", %{conn: conn, username: username, correct_password: correct_password} do
      credentials = %{username: username, password: correct_password} 
      conn = conn
        |> post(Routes.page_path(conn, :post_login), neighbor: credentials)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "POST / :login with incorrect credentials", %{conn: conn, username: username, incorrect_password: incorrect_password} do
      credentials = %{username: username, password: incorrect_password} 
        conn = conn
          |> post(Routes.page_path(conn, :post_login), neighbor: credentials)
  
        assert redirected_to(conn) == Routes.page_path(conn, :login)
      end
  end

  test "signup", %{conn: conn} do
    credentials = %{
      username: "name",
      password: "pass",
      create_neighbor: true,
      first_name: "jane",
      last_name: "doe"
    } 
    conn = conn
      |> post(Routes.page_path(conn, :post_login), neighbor: credentials)

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  test "logout", %{conn: conn, neighbor: neighbor} do
    conn = conn
      |> login_neighbor(neighbor)
      |> post(Routes.page_path(conn, :logout))

    assert redirected_to(conn) == "/"
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
