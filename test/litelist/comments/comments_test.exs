defmodule Litelist.CommentsTest do
  use Litelist.DataCase

  alias Litelist.Comments
  alias Litelist.Factory

  describe "comments" do
    alias Litelist.Comments.Comment

    @valid_attrs %{text: "some text"}
    @invalid_attrs %{text: nil}

    test "list_comments/0 returns all comments" do
      comment = Factory.insert(:comment)
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = Factory.insert(:comment)
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      neighbor = Factory.insert(:neighbor)
      assert {:ok, %Comment{} = comment} = Comments.create_comment(Map.merge(@valid_attrs, %{neighbor_id: neighbor.id}))
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "delete_comment/1 deletes the comment" do
      comment = Factory.insert(:comment)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = Factory.insert(:comment)
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end

    test "list_comments_by_post/1 returns all comments for a given post" do
      post = Factory.insert(:job)
      Factory.insert(:comment, %{post_id: post.id})
      Factory.insert(:comment, %{post_id: post.id})
      Factory.insert(:comment, %{post_id: post.id})
      Factory.insert(:comment)
      assert length(Comments.list_comments_by_post(post)) == 3
    end

    test "list_comments_by_discussion/1 returns all comments for a given discussion" do
      discussion = Factory.insert(:discussion)
      Factory.insert(:comment, %{discussion_id: discussion.id})
      Factory.insert(:comment, %{discussion_id: discussion.id})
      Factory.insert(:comment, %{discussion_id: discussion.id})
      Factory.insert(:comment)
      assert length(Comments.list_comments_by_discussion(discussion)) == 3
    end
  end
end
