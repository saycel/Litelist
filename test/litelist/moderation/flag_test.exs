defmodule Litelist.FlagTest do
    use Litelist.DataCase, async: true

    alias Litelist.Moderation.Flag

    alias Litelist.Repo
    alias Litelist.Factory

    describe "relationships" do
        test "Flag belongs_to Neighbor" do
            neighbor = Factory.insert(:neighbor)
            flag = Factory.insert(:flag, %{neighbor_id: neighbor.id})

            # credo:disable-for-lines:1
            post_result = Repo.get(Flag, flag.id) |> Repo.preload(:neighbor)

            assert post_result.neighbor == neighbor
        end

        test "Flag belongs_to Post" do
            post = Factory.insert(:job)
            flag = Factory.insert(:flag, %{post_id: post.id})

            # credo:disable-for-lines:1
            post_result = Repo.get(Flag, flag.id) |> Repo.preload(:post)

            assert post_result.post == post
        end
    end
end
