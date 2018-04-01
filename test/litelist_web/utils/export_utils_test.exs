defmodule LitelistWeb.ExportUtilsTest do
    use Litelist.DataCase, async: true
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

        test "returns correct info in csv" do
            title = "some title"
            neighbor = Factory.insert(:neighbor)
            Factory.insert(:job, %{neighbor_id: neighbor.id, title: title})
            csv = ExportUtils.build_posts_csv(neighbor)
            last_line = get_last_line_of_csv(csv)
            assert length(csv) == 2
            assert last_line =~ "some title"
        end
    end

    defp get_last_line_of_csv(csv) do
        [_ | tail] = csv
        [head | _] = tail
        head
    end
end