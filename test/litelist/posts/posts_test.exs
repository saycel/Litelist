defmodule Litelist.PostsTest do
  use Litelist.DataCase

  alias Litelist.Posts
  alias Litelist.Factory

  describe "for_sales" do
    alias Litelist.Posts.ForSale

    @valid_attrs %{"contact_info" => "some contact_info", "description" => "some description", "price" => 120.5, "title" => "some title"}
    @update_attrs %{"contact_info" => "some updated contact_info", "description" => "some updated description", "price" => 456.7, "title" => "some updated title"}
    @invalid_attrs %{"contact_info" => nil, "description" => nil, "price" => nil, "title" => nil}

    def for_sale_fixture(attrs \\ %{}) do
      neighbor = Factory.insert(:neighbor)

      {:ok, for_sale} = Posts.create_for_sale(neighbor.id, @valid_attrs)
      for_sale
    end

    test "list_for_sales/0 returns all for_sales" do
      for_sale = for_sale_fixture()
      assert Posts.list_for_sales() == [for_sale]
    end

    test "get_for_sale!/1 returns the for_sale with given id" do
      for_sale = for_sale_fixture()
      assert Posts.get_for_sale!(for_sale.id) == for_sale
    end

    test "create_for_sale/1 with valid data creates a for_sale" do
      neighbor = Factory.insert(:neighbor)    
      assert {:ok, %ForSale{} = for_sale} = Posts.create_for_sale(neighbor.id, @valid_attrs)
      assert for_sale.contact_info == "some contact_info"
      assert for_sale.description == "some description"
      assert for_sale.price == 120.5
      assert for_sale.title == "some title"
    end

    test "create_for_sale/1 with invalid data returns error changeset" do
      neighbor = Factory.insert(:neighbor)    
      assert {:error, %Ecto.Changeset{}} = Posts.create_for_sale(neighbor.id, @invalid_attrs)
    end

    test "update_for_sale/2 with valid data updates the for_sale" do
      for_sale = for_sale_fixture()
      assert {:ok, for_sale} = Posts.update_for_sale(for_sale, @update_attrs)
      assert %ForSale{} = for_sale
      assert for_sale.contact_info == "some updated contact_info"
      assert for_sale.description == "some updated description"
      assert for_sale.price == 456.7
      assert for_sale.title == "some updated title"
    end

    test "update_for_sale/2 with invalid data returns error changeset" do
      for_sale = for_sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_for_sale(for_sale, @invalid_attrs)
      assert for_sale == Posts.get_for_sale!(for_sale.id)
    end

    test "delete_for_sale/1 deletes the for_sale" do
      for_sale = for_sale_fixture()
      assert {:ok, %ForSale{}} = Posts.delete_for_sale(for_sale)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_for_sale!(for_sale.id) end
    end

    test "change_for_sale/1 returns a for_sale changeset" do
      for_sale = for_sale_fixture()
      assert %Ecto.Changeset{} = Posts.change_for_sale(for_sale)
    end
  end
end
