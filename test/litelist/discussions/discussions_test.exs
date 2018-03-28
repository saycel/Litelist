defmodule Litelist.DiscussionsTest do
  use Litelist.DataCase

  alias Litelist.Discussions
  alias Litelist.Factory

  describe "discussions" do
    alias Litelist.Discussions.Discussion

    @valid_attrs %{description: "some description", title: "some title", slug: "some-title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def discussion_fixture(attrs \\ %{}) do
      neighbor = Factory.insert(:neighbor)
      attrs = Map.merge(@valid_attrs, %{neighbor_id: neighbor.id})
      {:ok, discussion} =
        attrs
        |> Enum.into(attrs)
        |> Discussions.create_discussion()

      discussion
    end

    test "list_discussions/0 returns all discussions" do
      discussion = discussion_fixture()
      assert Discussions.list_discussions() == [discussion]
    end

    test "get_discussion!/1 returns the discussion with given id" do
      discussion = discussion_fixture()
      assert Discussions.get_discussion!(discussion.id) == discussion
    end

    test "create_discussion/1 with valid data creates a discussion" do
      neighbor = Factory.insert(:neighbor)
      attrs = Map.merge(@valid_attrs, %{neighbor_id: neighbor.id})
      assert {:ok, %Discussion{} = discussion} = Discussions.create_discussion(attrs)
      assert discussion.description == "some description"
      assert discussion.title == "some title"
    end

    test "create_discussion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discussions.create_discussion(@invalid_attrs)
    end

    test "update_discussion/2 with valid data updates the discussion" do
      discussion = discussion_fixture()
      assert {:ok, discussion} = Discussions.update_discussion(discussion, @update_attrs)
      assert %Discussion{} = discussion
      assert discussion.description == "some updated description"
      assert discussion.title == "some updated title"
    end

    test "update_discussion/2 with invalid data returns error changeset" do
      discussion = discussion_fixture()
      assert {:error, %Ecto.Changeset{}} = Discussions.update_discussion(discussion, @invalid_attrs)
      assert discussion == Discussions.get_discussion!(discussion.id)
    end

    test "delete_discussion/1 deletes the discussion" do
      discussion = discussion_fixture()
      assert {:ok, %Discussion{}} = Discussions.delete_discussion(discussion)
      assert_raise Ecto.NoResultsError, fn -> Discussions.get_discussion!(discussion.id) end
    end

    test "change_discussion/1 returns a discussion changeset" do
      discussion = discussion_fixture()
      assert %Ecto.Changeset{} = Discussions.change_discussion(discussion)
    end
  end

  describe "discussion_comments" do
    alias Litelist.Discussions.Comment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discussions.create_comment()

      comment
    end

    test "list_discussion_comments/0 returns all discussion_comments" do
      comment = comment_fixture()
      assert Discussions.list_discussion_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Discussions.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Discussions.create_comment(@valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discussions.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Discussions.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Discussions.update_comment(comment, @invalid_attrs)
      assert comment == Discussions.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Discussions.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Discussions.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Discussions.change_comment(comment)
    end
  end
end
