defmodule LitelistWeb.DashboardControllerTest do
    use LitelistWeb.ConnCase, async: true
    import Phoenix.Controller

    alias Litelist.Factory
    alias Litelist.Auth.Guardian
    alias Litelist.Posts

    describe "index" do
      test "shows the dashboard if logged in", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)
        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :index))
  
        assert html_response(conn, 200)
        assert view_template(conn) == "index.html"
      end

      test "redirects if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :index))
  
        assert response(conn, 401)
      end
    end

    describe "export" do
      test "exports posts if logged in", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :export_posts))
  
        assert get_resp_header(conn, "content-type") == ["text/csv; charset=utf-8"]
        assert response(conn, 200)
      end

      test "redirects from export posts if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :export_posts))
  
        assert response(conn, 401)
      end

      test "exports my flagged posts if logged in", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :export_my_flagged_posts))
  
        assert get_resp_header(conn, "content-type") == ["text/csv; charset=utf-8"]
        assert response(conn, 200)
      end

      test "redirects from export my flagged posts if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :export_my_flagged_posts))
  
        assert response(conn, 401)
      end

      test "exports export posts I flagged if logged in", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :export_posts_i_flagged))
  
        assert get_resp_header(conn, "content-type") == ["text/csv; charset=utf-8"]
        assert response(conn, 200)
      end

      test "redirects from export posts I flagged if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :export_posts_i_flagged))
  
        assert response(conn, 401)
      end

      test "exports my discussions if logged in", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :export_my_discussions))
  
        assert get_resp_header(conn, "content-type") == ["text/csv; charset=utf-8"]
        assert response(conn, 200)
      end

      test "redirects from export my discussions if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :export_my_discussions))
  
        assert response(conn, 401)
      end
    end

    describe "posts" do
      test "lists my posts", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :posts))
  
        assert html_response(conn, 200)
        assert view_template(conn) == "posts.html"
      end

      test "redirects from posts if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :posts))

        assert response(conn, 401)
      end
    end

    describe "my flagged posts" do
      test "lists my flagged posts", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :my_flagged_posts))
  
        assert html_response(conn, 200)
        assert view_template(conn) == "my_flagged_posts.html"

      end

      test "redirects from my flagged posts if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :my_flagged_posts))

        assert response(conn, 401)
      end
    end

    describe "posts I flagged" do
      test "lists posts I flagged", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :posts_i_flagged))
  
        assert html_response(conn, 200)
        assert view_template(conn) == "posts_i_flagged.html"

      end

      test "redirects from posts I flagged if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :posts_i_flagged))

        assert response(conn, 401)
      end
    end

    describe "my_discussions" do
      test "lists my_discussions", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)

        conn = conn
          |> login_neighbor(neighbor)
          |> get(dashboard_path(conn, :my_discussions))
  
        assert html_response(conn, 200)
        assert view_template(conn) == "my_discussions.html"

      end

      test "redirects from my_discussions if not logged in", %{conn: conn} do
        conn = conn
          |> get(dashboard_path(conn, :my_discussions))

        assert response(conn, 401)
      end
    end
  

    describe "delete_all" do
      test "deletes all posts created by the neighbor", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)
        Factory.insert(:business, %{neighbor_id: neighbor.id})
        assert Enum.empty?(Posts.list_posts_by_neighbor(neighbor)) == false
        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete_all))
  
        assert redirected_to(conn) == dashboard_path(conn, :posts)

        assert Enum.empty?(Posts.list_posts_by_neighbor(neighbor)) == true
      end
    end
    describe "delete post" do
  
      test "deletes chosen post", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)
        business = Factory.insert(:business, %{neighbor_id: neighbor.id})

        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete, business))

        assert redirected_to(conn) == dashboard_path(conn, :posts)
        assert_error_sent 404, fn ->
          get conn, business_path(conn, :show, business)
        end
      end
  
      test "deletes chosen post as an admin", %{conn: conn} do
        admin = Factory.insert(:admin)
        business = Factory.insert(:business)

        conn = conn
          |> login_neighbor(admin)
          |> delete(dashboard_path(conn, :delete, business))
  
        assert redirected_to(conn) == dashboard_path(conn, :posts)
        assert_error_sent 404, fn ->
          get conn, business_path(conn, :show, business)
        end
      end
  
      test "redirects to index if business was not created by the neighbor", %{conn: conn} do
        neighbor = Factory.insert(:neighbor)
        not_my_business = Factory.insert(:business)

        conn = conn
          |> login_neighbor(neighbor)
          |> delete(dashboard_path(conn, :delete, not_my_business))
  
          assert redirected_to(conn) == dashboard_path(conn, :posts)
      end
  
      test "unautorized 401 redirect if not logged in", %{conn: conn} do
        business = Factory.insert(:business)

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
  