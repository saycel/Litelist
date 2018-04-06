defmodule Litelist.PostTest do
    use Litelist.DataCase, async: true

    alias Litelist.Posts.Post

    alias Litelist.Repo
    alias Litelist.Factory

    describe "relationships" do
        test "Post belongs_to Neighbor" do
            my_neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:for_sale, %{neighbor_id: my_neighbor.id})

            # credo:disable-for-lines:1
            post_result = Repo.get(Post, post.id) |> Repo.preload(:neighbor)

            assert post_result.neighbor == my_neighbor
        end

        test "Post has_many Flags" do
            post = Factory.insert(:job)
            flag = Factory.insert(:flag, %{post_id: post.id})

            # credo:disable-for-lines:1
            neighbor_result = Repo.get(Post, post.id) |> Repo.preload([:flags])

            assert length(neighbor_result.flags) == 1
            assert neighbor_result.flags == [flag]
        end
    end
end
