defmodule Litelist.NeighborTest do
    use Litelist.DataCase, async: true

    alias Litelist.Auth.Neighbor
    alias Litelist.Repo
    alias Litelist.Factory

    describe "relationships" do
        test "Neighbor has_many Posts" do
            neighbor = Factory.insert(:neighbor)
            my_post = Factory.insert(:for_sale, %{neighbor_id: neighbor.id})
            Factory.insert(:for_sale) # This post does not belong to the neighbor

            # credo:disable-for-lines:1
            neighbor_result = Repo.get(Neighbor, neighbor.id) |> Repo.preload([:posts])

            assert length(neighbor_result.posts) == 1
            assert neighbor_result.posts == [my_post]
        end

        test "Neighbor has_many Flags" do
            neighbor = Factory.insert(:neighbor)
            my_flag = Factory.insert(:flag, %{neighbor_id: neighbor.id})

            # credo:disable-for-lines:1
            neighbor_result = Repo.get(Neighbor, neighbor.id) |> Repo.preload([:flags])

            assert length(neighbor_result.flags) == 1
            assert neighbor_result.flags == [my_flag]
        end
    end
end
