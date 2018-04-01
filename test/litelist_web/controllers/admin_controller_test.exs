defmodule LitelistWeb.AdminControllerTest do
    use LitelistWeb.ConnCase, async: true
  
    alias Litelist.Factory
    alias Litelist.Auth.Guardian
  
    setup do
      neighbor = Factory.insert(:neighbor)
      admin = Factory.insert(:neighbor, %{admin: true})
      {:ok, neighbor: neighbor, admin: admin}
    end
  
    describe "index" do
      test "shows the dashboard if logged in as an admin", %{conn: conn, admin: admin} do
        conn = conn
          |> login_neighbor(admin)
          |> get(admin_path(conn, :index))
  
        assert html_response(conn, 200) =~ "Dashboard"
      end

      test "redirects if logged in as non-admin", %{conn: conn, neighbor: neighbor} do
        conn = conn
          |> login_neighbor(neighbor)
          |> get(admin_path(conn, :index))
  
        assert response(conn, 401)
      end

      test "redirects if not logged in", %{conn: conn} do
        conn = conn
          |> get(admin_path(conn, :index))
  
        assert response(conn, 401)
      end
    end

    describe "posts" do
        test "shows the dashboard if logged in as an admin", %{conn: conn, admin: admin} do
          conn = conn
            |> login_neighbor(admin)
            |> get(admin_path(conn, :posts))
    
          assert html_response(conn, 200) =~ "Dashboard"
        end
  
        test "redirects if logged in as a non-admin", %{conn: conn, neighbor: neighbor} do
          conn = conn
            |> login_neighbor(neighbor)
            |> get(admin_path(conn, :posts))
    
          assert response(conn, 401)
        end
  
        test "redirects if not logged in", %{conn: conn} do
          conn = conn
            |> get(admin_path(conn, :posts))
    
          assert response(conn, 401)
        end
    end

    describe "settings" do
        test "shows the dashboard if logged in as an admin", %{conn: conn, admin: admin} do
          conn = conn
            |> login_neighbor(admin)
            |> get(admin_path(conn, :settings))
    
          assert html_response(conn, 200) =~ "Settings"
        end
  
        test "redirects if logged in as a non-admin", %{conn: conn, neighbor: neighbor} do
          conn = conn
            |> login_neighbor(neighbor)
            |> get(admin_path(conn, :settings))
    
          assert response(conn, 401)
        end
  
        test "redirects if not logged in", %{conn: conn} do
          conn = conn
            |> get(admin_path(conn, :settings))
    
          assert response(conn, 401)
        end
    end
  
    defp login_neighbor(conn, neighbor) do
      {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
      conn
        |> put_req_header("authorization", "bearer: " <> token)
    end
  end
  