defmodule LitelistWeb.DiscussionControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{"description" => "some description", "title" => "some title"}
  @update_attrs %{"description" => "some updated description", "title" => "some updated title"}
  @invalid_attrs %{"description" => nil, "title" => nil}


  setup do
    neighbor = Factory.insert(:neighbor)
    admin = Factory.insert(:neighbor, %{admin: true})
    discussion = Factory.insert(:discussion, neighbor_id: neighbor.id)
    not_my_discussion = Factory.insert(:discussion)
    {:ok, neighbor: neighbor, discussion: discussion, not_my_discussion: not_my_discussion, admin: admin}
  end

  describe "index" do
    test "lists all discussions", %{conn: conn} do
      conn = get conn, discussion_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Discussions"
    end
  end

  describe "new discussion" do
    test "renders form", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :new))
      
      assert html_response(conn, 200) =~ "New Discussion"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(discussion_path(conn, :new))
      
      assert response(conn, 401)
    end
  end

  describe "create discussions" do
    test "redirects to show when data is valid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(discussion_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == discussion_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, discussion_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Discussion"
    end

    test "renders errors when data is invalid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(discussion_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Discussion"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(discussion_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end
  end

  describe "edit discussion" do
    test "renders form for editing chosen discussion if admin", %{conn: conn, discussion: discussion, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> get(discussion_path(conn, :edit, discussion))
      assert html_response(conn, 200) =~ "Edit Discussion"
    end

    test "redirects to index if discussion was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_discussion: not_my_discussion} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :edit, not_my_discussion))
      assert redirected_to(conn) == discussion_path(conn, :index)
    end

    test "redirects to index if discussion was created by the neighbor, but user is not admin", %{conn: conn, discussion: discussion, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :edit, discussion))
      assert redirected_to(conn) == discussion_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, discussion: discussion} do
      conn = conn
        |> get(discussion_path(conn, :edit, discussion))
      
      assert response(conn, 401)
    end
  end

  describe "update discussion" do

    test "redirects to index when discussion is created by the neighbor, but the neighbor is not an admin", %{conn: conn, discussion: discussion, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(discussion_path(conn, :update, discussion), post: @update_attrs)

      assert redirected_to(conn) == discussion_path(conn, :index)
    end

    test "redirects when data is valid as an admin", %{conn: conn, discussion: discussion, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(discussion_path(conn, :update, discussion), post: @update_attrs)

      assert redirected_to(conn) == discussion_path(conn, :show, discussion)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, discussion_path(conn, :show, discussion)
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, discussion: discussion, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(discussion_path(conn, :update, discussion), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Discussion"
    end

    test "redirects to index if discussion was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_discussion: not_my_discussion} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(discussion_path(conn, :update, not_my_discussion), post: @invalid_attrs)

        assert redirected_to(conn) == discussion_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, discussion: discussion} do
      conn = conn
        |> put(discussion_path(conn, :update, discussion), post: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete discussion" do
    test "deletes chosen discussion as an admin", %{conn: conn, discussion: discussion, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> delete(discussion_path(conn, :delete, discussion))

      assert redirected_to(conn) == discussion_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, discussion_path(conn, :show, discussion)
      end
    end

    test "redirects to index if discussion is not deleted by an admin", %{conn: conn, neighbor: neighbor, discussion: discussion} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(discussion_path(conn, :delete, discussion))

        assert redirected_to(conn) == discussion_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, discussion: discussion} do
      conn = conn
        |> delete(discussion_path(conn, :delete, discussion))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
