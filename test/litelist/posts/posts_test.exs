defmodule Litelist.PostsTest do
  use Litelist.DataCase, async: true

  alias Litelist.Posts
  alias Litelist.Posts.Post
  alias Litelist.Factory
  
  describe "posts" do
    alias Litelist.Posts.Post

    @valid_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", location: "some location", position_name: "some position_name", price: 120.5, salary: "some salary", slug: "some slug", title: "some title", type: "some type", url: "some url"}
    @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", location: "some updated location", position_name: "some updated position_name", price: 456.7, salary: "some updated salary", slug: "some updated slug", title: "some updated title", type: "some updated type", url: "some updated url"}
    @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, location: nil, position_name: nil, price: nil, salary: nil, slug: nil, title: nil, type: nil, url: nil}

    test "list_posts/0 returns all posts" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert Posts.get_post!(post.id).id == post.id
    end

    test "create_post/1 with valid data creates a post" do
      neighbor = Factory.insert(:neighbor)
      attrs = Map.merge(@valid_attrs, %{neighbor_id: neighbor.id})
      assert {:ok, %Post{} = post} = Posts.create_post(attrs)
      assert post.company_name == "some company_name"
      assert post.contact_info == "some contact_info"
      assert post.description == "some description"
      assert post.location == "some location"
      assert post.neighbor_id == neighbor.id
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
    end

    test "delete_post/1 deletes the post" do
      post = Factory.insert(:for_sale, @valid_attrs)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "delete_all_by_neighbor/1 deletes all posts for a neighbor" do
      neighbor = Factory.insert(:neighbor)
      Factory.insert(:for_sale, %{neighbor_id: neighbor.id})
      Factory.insert(:for_sale, %{neighbor_id: neighbor.id})
      Factory.insert(:for_sale)

      assert length(Repo.all(Post)) == 3
      Posts.delete_all_by_neighbor(neighbor)
      assert length(Repo.all(Post)) == 1
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

    test "list_posts_by_neighbor/1 will only return posts created by a given neighbor" do
      neighbor = Factory.insert(:neighbor)
      different_neighbor = Factory.insert(:neighbor)

      Factory.insert(:for_sale, %{neighbor_id: neighbor.id})
      Factory.insert(:for_sale, %{neighbor_id: neighbor.id})
      Factory.insert(:for_sale, %{neighbor_id: different_neighbor.id})

      posts_with_same_neighbor = Posts.list_posts_by_neighbor(neighbor)
      posts_with_different_neighbor = Posts.list_posts_by_neighbor(different_neighbor)

      assert length(posts_with_same_neighbor) == 2
      assert length(posts_with_different_neighbor) == 1
    end
  end

  test "delete_expired_posts" do
    create_old_post()
    Posts.delete_expired_posts()
    assert_post_deleted()
  end

  test "get_pending_flag_count" do
    post = Factory.insert(:job)
    Factory.insert_list(3, :flag, %{post_id: post.id})
    Factory.insert(:flag)
    assert Posts.get_pending_flag_count(post) == 3
  end

  describe "get_expired_posts" do
    test "it should get an old post,
                      if that post doesn't have an end_date or end_time" do
      create_old_post()
      assert length(get_expired_posts_count()) == 1
    end

    test "it should get an old post,
                      if that post has an end_date that is in the past and end_time is nil" do
        create_old_post_old_end_date_nil_end_time()
        assert length(get_expired_posts_count()) == 1
    end

    test "it should get an old post,
                      if that post has an end_time that is in the past and end_date is nil " do
        create_old_post_old_end_time_nil_end_date()
        assert length(get_expired_posts_count()) == 1

    end

    test "it should get an old post,
                      if that post has and end_date and end_time in the past" do

      create_old_post_old_end_time_old_end_date()
      assert length(get_expired_posts_count()) == 1
    end

    test "it should not get an old post,
                    if the post is not older than the setting" do
      create_recent_post()
      assert Enum.empty?(get_expired_posts_count())

    end

    test "it should not get an old post,
                    if there is an end_date in the future" do

      create_old_post_end_date_future()
      assert Enum.empty?(get_expired_posts_count())
    end

    test "it should not delete an old post,
                    if there is an end_time in the future" do
      create_old_post_end_time_future()
      assert Enum.empty?(get_expired_posts_count())
    end
  end

  defp get_expired_posts_count() do
    Repo.all(Posts.get_expired_posts_query())
  end

  defp assert_post_deleted() do
    all_posts = Repo.all(Post)
    assert Enum.empty?(all_posts)
  end

  # defp assert_post_not_deleted() do
  #   all_posts = Repo.all(Post)
  #   assert length(all_posts) == 1
  # end

  defp create_old_post() do 
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    Factory.insert(:job, %{inserted_at: inserted_at, end_date: nil, end_time: nil})
  end

  defp create_old_post_old_end_date_nil_end_time() do
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    yesterday_date = Timex.shift(Timex.today, days: -1)
    Factory.insert(:job, %{inserted_at: inserted_at, end_date: yesterday_date, end_time: nil})
  end

  defp create_old_post_old_end_time_nil_end_date() do
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    yesterday_time = Timex.shift(Timex.now, days: -1)
    Factory.insert(:job, %{inserted_at: inserted_at, end_time: yesterday_time, end_date: nil})
  end

  defp create_old_post_old_end_time_old_end_date() do
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    yesterday_time = Timex.shift(Timex.now, days: -1)
    yesterday_date = Timex.shift(Timex.today, days: -1)
    Factory.insert(:job, %{inserted_at: inserted_at, end_time: yesterday_time, end_date: yesterday_date})
  end

  defp create_recent_post() do
    days_old = 10
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    Factory.insert(:job, %{inserted_at: inserted_at})
  end

  defp create_old_post_end_date_future() do
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    tomorrow_date = Timex.shift(Timex.today, days: 1)
    Factory.insert(:job, %{inserted_at: inserted_at, end_date: tomorrow_date})
  end

  defp create_old_post_end_time_future() do
    days_old = 100
    inserted_at = Timex.shift(Timex.now, days: -days_old)
    tomorrow_time = Timex.shift(Timex.now, days: 1)
    Factory.insert(:job, %{inserted_at: inserted_at, end_time: tomorrow_time})
  end
end
