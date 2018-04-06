defmodule LitelistWeb.DiscussionControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  describe "index" do
    test "lists all discussions", %{conn: conn} do
      conn = conn
        |> get(discussion_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Discussions"
    end
  end

  describe "show" do
    test "shows a discussion if the type matches", %{conn: conn} do
      discussion = Factory.insert(:discussion)
      conn = conn
        |> get(discussion_path(conn, :show, discussion))

      assert html_response(conn, 200) =~ discussion.title
    end
  end

  describe "new discussion" do
    test "renders form", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :new))
      
      assert html_response(conn, 200) =~ "Title"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(discussion_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create discussion" do
    test "redirects to show when data is valid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      conn = conn
        |> login_neighbor(neighbor)
        |> post(discussion_path(conn, :create), discussion: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == discussion_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, discussion_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Discussion"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      conn = conn
        |> login_neighbor(neighbor)
        |> post(discussion_path(conn, :create), discussion: @invalid_attrs)
      assert html_response(conn, 200) =~ "Title"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(discussion_path(conn, :create), discussion: @create_attrs)
      assert response(conn, 401)
    end

    test "renders errors when title is not unique", %{conn: conn} do
      Factory.insert(:discussion, %{title: "some title"})
      neighbor = Factory.insert(:neighbor)
      conn = conn
        |> login_neighbor(neighbor)
        |> post(discussion_path(conn, :create), discussion: @create_attrs)
      assert html_response(conn, 200) =~ "Title"
    end
  end

  describe "edit discussion" do
    test "renders form for editing chosen discussion", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      discussion = Factory.insert(:discussion, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :edit, discussion))
      assert response(conn, 401)
    end

    test "renders form for editing chosen discussion if admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      discussion = Factory.insert(:discussion)

      conn = conn
        |> login_neighbor(admin)
        |> get(discussion_path(conn, :edit, discussion))
      assert html_response(conn, 200) =~ "Title"
    end

    test "401 if discussion was created by the neighbor but neighbor is not an admin", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      not_my_discussion = Factory.insert(:discussion)

      conn = conn
        |> login_neighbor(neighbor)
        |> get(discussion_path(conn, :edit, not_my_discussion))
      assert response(conn, 401)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      discussion = Factory.insert(:discussion)

      conn = conn
        |> get(discussion_path(conn, :edit, discussion))
      
      assert response(conn, 401)
    end
  end

  describe "update discussion" do

    test "401 when logged in neighbor is not an admin", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      discussion = Factory.insert(:discussion, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> put(discussion_path(conn, :update, discussion), discussion: @update_attrs)
      assert response(conn, 401)
    end

    test "redirects when data is valid as an admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      discussion = Factory.insert(:discussion)

      conn = conn
        |> login_neighbor(admin)
        |> put(discussion_path(conn, :update, discussion), discussion: @update_attrs)

      assert redirected_to(conn) == discussion_path(conn, :show, discussion)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, discussion_path(conn, :show, discussion)
      assert html_response(conn, 200) =~ "updated title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      admin = Factory.insert(:admin)
      discussion = Factory.insert(:discussion, %{neighbor_id: admin.id})

      conn = conn
        |> login_neighbor(admin)
        |> put(discussion_path(conn, :update, discussion), discussion: @invalid_attrs)

      assert html_response(conn, 200) =~ "Title"
    end

    test "401 if discussion was not created by the neighbor", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      not_my_discussion = Factory.insert(:discussion)

      conn = conn
        |> login_neighbor(neighbor)
        |> put(discussion_path(conn, :update, not_my_discussion), discussion: @invalid_attrs)

      assert response(conn, 401)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      discussion = Factory.insert(:discussion)
      conn = conn
        |> put(discussion_path(conn, :update, discussion), discussion: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete discussion" do

    test " 401 if logged in neighbor is not admin", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      discussion = Factory.insert(:discussion, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> delete(discussion_path(conn, :delete, discussion))

        assert response(conn, 401)
    end

    test "deletes chosen discussion as an admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      discussion = Factory.insert(:discussion)

      conn = conn
        |> login_neighbor(admin)
        |> delete(discussion_path(conn, :delete, discussion))

      assert redirected_to(conn) == discussion_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, discussion_path(conn, :show, discussion)
      end
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      discussion = Factory.insert(:discussion)

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
