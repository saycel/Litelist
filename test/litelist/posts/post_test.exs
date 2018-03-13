defmodule Litelist.NeighborTest do
    use Litelist.DataCase

    alias Litelist.Auth.Neighbor
    alias Litelist.Posts.Post

    alias Litelist.Repo
    alias Litelist.Factory

    describe "relationships" do
        test "Post belongs_to Neighbor" do
            my_neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:for_sale, %{neighbor_id: my_neighbor.id})

            post_result = Repo.get(Post, post.id) |> Repo.preload(:neighbor)

            assert post_result.neighbor == my_neighbor
        end
    end
end
