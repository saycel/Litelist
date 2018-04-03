defmodule Litelist.ModerationTest do
  use Litelist.DataCase

  alias Litelist.Moderation

  describe "flags" do
    alias Litelist.Moderation.Flag

    @valid_attrs %{admin_response: "some admin_response", description: "some description", status: "some status", type: "some type"}
    @update_attrs %{admin_response: "some updated admin_response", description: "some updated description", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{admin_response: nil, description: nil, status: nil, type: nil}

    def flag_fixture(attrs \\ %{}) do
      {:ok, flag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Moderation.create_flag()

      flag
    end

    test "list_flags/0 returns all flags" do
      flag = flag_fixture()
      assert Moderation.list_flags() == [flag]
    end

    test "get_flag!/1 returns the flag with given id" do
      flag = flag_fixture()
      assert Moderation.get_flag!(flag.id) == flag
    end

    test "create_flag/1 with valid data creates a flag" do
      assert {:ok, %Flag{} = flag} = Moderation.create_flag(@valid_attrs)
      assert flag.admin_response == "some admin_response"
      assert flag.description == "some description"
      assert flag.status == "some status"
      assert flag.type == "some type"
    end

    test "create_flag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Moderation.create_flag(@invalid_attrs)
    end

    test "update_flag/2 with valid data updates the flag" do
      flag = flag_fixture()
      assert {:ok, flag} = Moderation.update_flag(flag, @update_attrs)
      assert %Flag{} = flag
      assert flag.admin_response == "some updated admin_response"
      assert flag.description == "some updated description"
      assert flag.status == "some updated status"
      assert flag.type == "some updated type"
    end

    test "update_flag/2 with invalid data returns error changeset" do
      flag = flag_fixture()
      assert {:error, %Ecto.Changeset{}} = Moderation.update_flag(flag, @invalid_attrs)
      assert flag == Moderation.get_flag!(flag.id)
    end

    test "delete_flag/1 deletes the flag" do
      flag = flag_fixture()
      assert {:ok, %Flag{}} = Moderation.delete_flag(flag)
      assert_raise Ecto.NoResultsError, fn -> Moderation.get_flag!(flag.id) end
    end

    test "change_flag/1 returns a flag changeset" do
      flag = flag_fixture()
      assert %Ecto.Changeset{} = Moderation.change_flag(flag)
    end
  end
end
