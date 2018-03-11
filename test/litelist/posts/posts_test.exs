defmodule Litelist.PostsTest do
  use Litelist.DataCase

  alias Litelist.Posts
  alias Litelist.Factory
  
  describe "posts" do
    alias Litelist.Posts.Post

    @valid_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", location: "some location", neighbor_id: 42, position_name: "some position_name", price: 120.5, salary: "some salary", slug: "some slug", title: "some title", type: "some type", url: "some url"}
    @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", location: "some updated location", neighbor_id: 43, position_name: "some updated position_name", price: 456.7, salary: "some updated salary", slug: "some updated slug", title: "some updated title", type: "some updated type", url: "some updated url"}
    @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, location: nil, neighbor_id: nil, position_name: nil, price: nil, salary: nil, slug: nil, title: nil, type: nil, url: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert post.company_name == "some company_name"
      assert post.contact_info == "some contact_info"
      assert post.description == "some description"
      assert post.location == "some location"
      assert post.neighbor_id == 42
      assert post.position_name == "some position_name"
      assert post.price == 120.5
      assert post.salary == "some salary"
      assert post.slug == "some slug"
      assert post.title == "some title"
      assert post.type == "some type"
      assert post.url == "some url"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert {:ok, post} = Posts.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.company_name == "some updated company_name"
      assert post.contact_info == "some updated contact_info"
      assert post.description == "some updated description"
      assert post.location == "some updated location"
      assert post.neighbor_id == 43
      assert post.position_name == "some updated position_name"
      assert post.price == 456.7
      assert post.salary == "some updated salary"
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
      assert post.type == "some updated type"
      assert post.url == "some updated url"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end

    test "posts cannot have identical urls" do
      Factory.insert(:for_sale, @valid_attrs)
      assert_raise Ecto.ConstraintError, fn -> Factory.insert(:for_sale, @valid_attrs) end
    end

    test "list_posts_by_type/1 will only return posts of a given type" do
      same_type = "same_type"
      different_type = "different_type"

      Factory.insert(:for_sale, %{type: same_type})
      Factory.insert(:for_sale, %{type: same_type})
      Factory.insert(:for_sale, %{type: different_type})

      posts_with_same_type = Posts.list_posts_by_type(same_type)
      posts_with_different_type = Posts.list_posts_by_type(different_type)

      assert length(posts_with_same_type) == 2
      assert length(posts_with_different_type) == 1
    end
  end
end
