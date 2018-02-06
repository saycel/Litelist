defmodule Litelist.AuthTest do
  use Litelist.DataCase

  alias Litelist.Auth

  describe "neighbors" do
    alias Litelist.Auth.Neighbor

    @valid_attrs %{password: "some password", username: "some username"}
    @update_attrs %{password: "some updated password", username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    def neighbor_fixture(attrs \\ %{}) do
      {:ok, neighbor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_neighbor()

      neighbor
    end

    test "list_neighbors/0 returns all neighbors" do
      neighbor = neighbor_fixture()
      assert Auth.list_neighbors() == [neighbor]
    end

    test "get_neighbor!/1 returns the neighbor with given id" do
      neighbor = neighbor_fixture()
      assert Auth.get_neighbor!(neighbor.id) == neighbor
    end

    test "create_neighbor/1 with valid data creates a neighbor" do
      assert {:ok, %Neighbor{} = neighbor} = Auth.create_neighbor(@valid_attrs)
      assert neighbor.password == "some password"
      assert neighbor.username == "some username"
    end

    test "create_neighbor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_neighbor(@invalid_attrs)
    end

    test "update_neighbor/2 with valid data updates the neighbor" do
      neighbor = neighbor_fixture()
      assert {:ok, neighbor} = Auth.update_neighbor(neighbor, @update_attrs)
      assert %Neighbor{} = neighbor
      assert neighbor.password == "some updated password"
      assert neighbor.username == "some updated username"
    end

    test "update_neighbor/2 with invalid data returns error changeset" do
      neighbor = neighbor_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_neighbor(neighbor, @invalid_attrs)
      assert neighbor == Auth.get_neighbor!(neighbor.id)
    end

    test "delete_neighbor/1 deletes the neighbor" do
      neighbor = neighbor_fixture()
      assert {:ok, %Neighbor{}} = Auth.delete_neighbor(neighbor)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_neighbor!(neighbor.id) end
    end

    test "change_neighbor/1 returns a neighbor changeset" do
      neighbor = neighbor_fixture()
      assert %Ecto.Changeset{} = Auth.change_neighbor(neighbor)
    end
  end
end
