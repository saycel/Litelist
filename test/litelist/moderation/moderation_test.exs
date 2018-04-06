defmodule Litelist.ModerationTest do
  use Litelist.DataCase

  alias Litelist.Moderation
  alias Litelist.Factory

  describe "flags" do
    alias Litelist.Moderation.Flag

    @valid_attrs %{admin_response: "some admin_response", description: "some description", status: "pending", type: "Incorrect information"}
    @update_attrs %{admin_response: "some updated admin_response", description: "some updated description", status: "post_removed", type: "Abusive"}
    @invalid_attrs %{admin_response: nil, description: nil, status: nil, type: nil}

    def flag_fixture(attrs \\ %{}) do
      {:ok, flag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Moderation.create_flag()

      flag
    end

    test "list_flags/0 returns all flags" do
      flag = Factory.insert(:flag)
      assert Moderation.list_flags() == [flag]
    end

    test "get_flag!/1 returns the flag with given id" do
      flag = Factory.insert(:flag)
      assert Moderation.get_flag!(flag.id) == flag
    end

    test "create_flag/1 with valid data creates a flag" do
      post = Factory.insert(:job)
      attrs = Map.merge(@valid_attrs, %{post_id: post.id})
      assert {:ok, %Flag{} = flag} = Moderation.create_flag(attrs)
      assert flag.admin_response == "some admin_response"
      assert flag.description == "some description"
      assert flag.status == "pending"
      assert flag.type == "Incorrect information"
    end

    test "create_flag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Moderation.create_flag(@invalid_attrs)
    end

    test "update_flag/2 with valid data updates the flag" do
      flag = Factory.insert(:flag)
      assert {:ok, flag} = Moderation.update_flag(flag, @update_attrs)
      assert %Flag{} = flag
      assert flag.admin_response == "some updated admin_response"
      assert flag.description == "some updated description"
      assert flag.status == "post_removed"
      assert flag.type == "Abusive"
    end

    test "update_flag/2 with invalid data returns error changeset" do
      flag = Factory.insert(:flag)
      assert {:error, %Ecto.Changeset{}} = Moderation.update_flag(flag, @invalid_attrs)
      assert flag == Moderation.get_flag!(flag.id)
    end

    test "delete_flag/1 deletes the flag" do
      flag = Factory.insert(:flag)
      assert {:ok, %Flag{}} = Moderation.delete_flag(flag)
      assert_raise Ecto.NoResultsError, fn -> Moderation.get_flag!(flag.id) end
    end

    test "change_flag/1 returns a flag changeset" do
      flag = Factory.insert(:flag)
      assert %Ecto.Changeset{} = Moderation.change_flag(flag)
    end

    test "list_flags_by_neighbor/1 will only return flags created by a given neighbor" do
      neighbor = Factory.insert(:neighbor)
      different_neighbor = Factory.insert(:neighbor)

      Factory.insert(:flag, %{neighbor_id: neighbor.id})
      Factory.insert(:flag, %{neighbor_id: neighbor.id})
      Factory.insert(:flag, %{neighbor_id: different_neighbor.id})

      flags_with_same_neighbor = Moderation.list_flags_by_neighbor(neighbor)
      flags_with_different_neighbor = Moderation.list_flags_by_neighbor(different_neighbor)

      assert length(flags_with_same_neighbor) == 2
      assert length(flags_with_different_neighbor) == 1
    end
  end
end
