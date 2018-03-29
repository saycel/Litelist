defmodule LitelistWeb.ExportUtilsTest do
    use Litelist.DataCase
    alias LitelistWeb.Utils.ExportUtils
    alias Litelist.Factory

    describe "build_posts_csv" do
        test "returns correctly formatted csv" do
            post_count = 10
            neighbor = Factory.insert(:neighbor)
            Factory.insert_list(post_count, :job, %{neighbor_id: neighbor.id})
            csv = ExportUtils.build_posts_csv(neighbor)
            [head | _] = csv
            assert length(csv) == post_count + 1
            assert head =~ "title"
        end
    end
end