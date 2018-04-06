defmodule LitelistWeb.ExportUtilsTest do
    use Litelist.DataCase, async: true
    alias LitelistWeb.Utils.ExportUtils
    alias Litelist.Factory

    describe "build_posts_csv" do
        test "returns correctly formatted csv" do
            build_count = 3
            neighbor = Factory.insert(:neighbor)
            Factory.insert_list(build_count, :job, %{neighbor_id: neighbor.id})
            csv = ExportUtils.build_posts_csv(neighbor)
            [head | _] = csv
            assert length(csv) == build_count + 1
            assert head =~ "title"
        end

        test "returns correct info in csv" do
            title = "some title"
            neighbor = Factory.insert(:neighbor)
            Factory.insert(:job, %{neighbor_id: neighbor.id, title: title})
            csv = ExportUtils.build_posts_csv(neighbor)
            last_line = get_last_line_of_csv(csv)
            assert length(csv) == 2
            assert last_line =~ title
        end
    end

    describe "build_discussions_csv" do
        test "returns correctly formatted csv" do
            build_count = 3
            neighbor = Factory.insert(:neighbor)
            Factory.insert_list(build_count, :discussion, %{neighbor_id: neighbor.id})
            csv = ExportUtils.build_discussions_csv(neighbor)
            [head | _] = csv
            assert length(csv) == build_count + 1
            assert head =~ "title"
        end

        test "returns correct info in csv" do
            title = "some title"
            neighbor = Factory.insert(:neighbor)
            Factory.insert(:discussion, %{neighbor_id: neighbor.id, title: title})
            csv = ExportUtils.build_discussions_csv(neighbor)
            last_line = get_last_line_of_csv(csv)
            assert length(csv) == 2
            assert last_line =~ title
        end
    end

    describe "build_posts_i_flagged" do
        test "returns correctly formatted csv" do
            build_count = 3
            neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:job)
            Factory.insert_list(build_count, :flag, %{neighbor_id: neighbor.id, post_id: post.id})
            csv = ExportUtils.build_posts_i_flagged(neighbor)
            [head | _] = csv
            assert length(csv) == build_count + 1
            assert head =~ "title"
        end

        test "returns correct info in csv" do
            description = "some description"
            neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:job)
            Factory.insert(:flag, %{neighbor_id: neighbor.id, description: description, post_id: post.id})
            csv = ExportUtils.build_posts_i_flagged(neighbor)
            last_line = get_last_line_of_csv(csv)
            assert length(csv) == 2
            assert last_line =~ description
        end
    end

    describe "build_my_flagged_posts_csv" do
        test "returns correctly formatted csv" do
            build_count = 3
            neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:job, %{neighbor_id: neighbor.id})
            Factory.insert_list(build_count, :flag, %{neighbor_id: neighbor.id, post_id: post.id})
            csv = ExportUtils.build_my_flagged_posts_csv(neighbor)
            [head | _] = csv
            assert length(csv) == build_count + 1
            assert head =~ "title"
        end

        test "returns correct info in csv" do
            description = "some description"
            neighbor = Factory.insert(:neighbor)
            other_neighbor = Factory.insert(:neighbor)
            post = Factory.insert(:job, %{neighbor_id: neighbor.id})
            Factory.insert(:flag, %{neighbor_id: other_neighbor.id, description: description, post_id: post.id})
            csv = ExportUtils.build_my_flagged_posts_csv(neighbor)
            last_line = get_last_line_of_csv(csv)
            assert length(csv) == 2
            assert last_line =~ description
        end
    end

    defp get_last_line_of_csv(csv) do
        [_ | tail] = csv
        [head | _] = tail
        head
    end
end