defmodule Litelist.PostTest do
    use Litelist.DataCase, async: true

    alias Litelist.Posts
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

        test "Post has_many Images" do
            {:ok, post} = create_post_with_image()
            assert length(post.images) == 1
        end
    end

    def create_post_with_image() do
        neighbor = Factory.insert(:neighbor)
        Posts.create_post(
            %{
                title: "Community Center post-march",
                type: "emergency_information",
                description: "Safe space to decompress after march",
                location: "900 Church Ave",
                contact_info: "347-882-2212",
                url: "dicks-emergency-dsf-dsfsfdsdf",
                images: [
                    %{
                        "image" => %Plug.Upload{
                            content_type: "image/jpeg",
                            filename: "communitycenter.jpg",
                            path: "priv/seed_photos/communitycenter.jpg"
                        }
                    }
                ],
                slug: "12397",
                neighbor_id: neighbor.id
            }
        )
    end
end
