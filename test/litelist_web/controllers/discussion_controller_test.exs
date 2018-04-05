defmodule LitelistWeb.DiscussionControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Discussions

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:discussion) do
    {:ok, discussion} = Discussions.create_discussion(@create_attrs)
    discussion
  end

  describe "index" do
    test "lists all discussions", %{conn: conn} do
      conn = get conn, discussion_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Discussions"
    end
  end

  describe "new discussion" do
    test "renders form", %{conn: conn} do
      conn = get conn, discussion_path(conn, :new)
      assert html_response(conn, 200) =~ "New Discussion"
    end
  end

  describe "create discussion" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, discussion_path(conn, :create), discussion: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == discussion_path(conn, :show, id)

      conn = get conn, discussion_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Discussion"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, discussion_path(conn, :create), discussion: @invalid_attrs
      assert html_response(conn, 200) =~ "New Discussion"
    end
  end

  describe "edit discussion" do
    setup [:create_discussion]

    test "renders form for editing chosen discussion", %{conn: conn, discussion: discussion} do
      conn = get conn, discussion_path(conn, :edit, discussion)
      assert html_response(conn, 200) =~ "Edit Discussion"
    end
  end

  describe "update discussion" do
    setup [:create_discussion]

    test "redirects when data is valid", %{conn: conn, discussion: discussion} do
      conn = put conn, discussion_path(conn, :update, discussion), discussion: @update_attrs
      assert redirected_to(conn) == discussion_path(conn, :show, discussion)

      conn = get conn, discussion_path(conn, :show, discussion)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, discussion: discussion} do
      conn = put conn, discussion_path(conn, :update, discussion), discussion: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Discussion"
    end
  end

  describe "delete discussion" do
    setup [:create_discussion]

    test "deletes chosen discussion", %{conn: conn, discussion: discussion} do
      conn = delete conn, discussion_path(conn, :delete, discussion)
      assert redirected_to(conn) == discussion_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, discussion_path(conn, :show, discussion)
      end
    end
  end

  defp create_discussion(_) do
    discussion = fixture(:discussion)
    {:ok, discussion: discussion}
  end
end
