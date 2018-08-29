defmodule Litelist.CommentTest do
  use Litelist.DataCase, async: true

  alias Litelist.Comments.Comment
  alias Litelist.Repo
  alias Litelist.Factory

  describe "relationships" do
    test "Comment belongs_to Post" do
        post = Factory.insert(:job)
        comment = Factory.insert(:comment, %{post_id: post.id})

        # credo:disable-for-lines:1
        comment_result = Repo.get(Comment, comment.id) |> Repo.preload(:post)

        assert comment_result.post == post
    end

    test "Comment belongs_to Discussion" do
      discussion = Factory.insert(:discussion)
      comment = Factory.insert(:comment, %{discussion_id: discussion.id})

      # credo:disable-for-lines:1
      comment_result = Repo.get(Comment, comment.id) |> Repo.preload(:discussion)

      assert comment_result.discussion == discussion
    end
  end
end