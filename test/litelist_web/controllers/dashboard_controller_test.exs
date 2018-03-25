defmodule LitelistWeb.DashboardControllerTest do
    use LitelistWeb.ConnCase
  
    alias Litelist.Factory
    alias Litelist.Auth.Guardian
    alias Litelist.Posts
  
    setup do
      neighbor = Factory.insert(:neighbor)
      admin = Factory.insert(:neighbor, %{admin: true})
      business = Factory.insert(:business, neighbor_id: neighbor.id)
      not_my_business = Factory.insert(:business)
      {:ok, neighbor: neighbor, business: business, not_my_business: not_my_business, admin: admin}
    end
  
    describe "index" do
      test "shows the dashboard", %{conn: conn, neighbor: neighbor} do
        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :index))
  
        assert html_response(conn, 200) =~ "Dashboard"
      end
    end

    describe "posts" do
        test "lists all posts", %{conn: conn, neighbor: neighbor} do
          conn = conn
            |> login_neighbor(neighbor)
            |> get(dashboard_path(conn, :posts))
    
          assert html_response(conn, 200) =~ "My Posts"
        end
      end
  

    describe "delete_all" do
      test "deletes all posts created by the neighbor", %{conn: conn, neighbor: neighbor} do
        Factory.insert(:business, %{neighbor_id: neighbor.id})
        Factory.insert(:business, %{neighbor_id: neighbor.id})
        Factory.insert(:business, %{neighbor_id: neighbor.id})
        assert length(Posts.list_posts_by_neighbor(neighbor)) == 4 #including the post created in setup
        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete_all))
  
        assert redirected_to(conn) == dashboard_path(conn, :posts)

        assert length(Posts.list_posts_by_neighbor(neighbor)) == 0
      end
    end
    describe "delete post" do
  
      test "deletes chosen post", %{conn: conn, business: business, neighbor: neighbor} do
        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete, business))

        assert redirected_to(conn) == dashboard_path(conn, :posts)
        assert_error_sent 404, fn ->
          get conn, business_path(conn, :show, business)
        end
      end
  
      test "deletes chosen post as an admin", %{conn: conn, business: business, admin: admin} do
        conn = conn
          |> login_neighbor(admin)
          |> delete(dashboard_path(conn, :delete, business))
  
        assert redirected_to(conn) == dashboard_path(conn, :posts)
        assert_error_sent 404, fn ->
          get conn, business_path(conn, :show, business)
        end
      end
  
      test "redirects to index if business was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_business: not_my_business} do
        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete, not_my_business))
  
          assert redirected_to(conn) == dashboard_path(conn, :posts)
      end
  
      test "unautorized 401 redirect if not logged in", %{conn: conn, business: business} do
        conn = conn
          |> delete(dashboard_path(conn, :delete, business))
  
        assert response(conn, 401)
      end
    end
  
    defp login_neighbor(conn, neighbor) do
      {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
      conn
        |> put_req_header("authorization", "bearer: " <> token)
    end
  end
  