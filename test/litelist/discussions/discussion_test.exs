defmodule Litelist.DiscussionTest do
  use Litelist.DataCase, async: true

  alias Litelist.Discussions.Discussion
  alias Litelist.Repo
  alias Litelist.Factory

  describe "relationships" do
    test "Discussion has_many Comments" do
        discussion = Factory.insert(:discussion)
        comment = Factory.insert(:comment, %{discussion_id: discussion.id})

        # credo:disable-for-lines:1
        discussion_result = Repo.get(Discussion, discussion.id) |> Repo.preload(:comments)

        
        assert length(discussion_result.comments) == 1
        assert discussion_result.comments == [comment]
    end

    test "Discussion belongs_to Neighbor" do
      neighbor = Factory.insert(:neighbor)
      discussion = Factory.insert(:discussion, %{neighbor_id: neighbor.id})

      # credo:disable-for-lines:1
      discussion_result = Repo.get(Discussion, discussion.id) |> Repo.preload(:neighbor)

      assert discussion_result.neighbor == neighbor

    end
  end
end