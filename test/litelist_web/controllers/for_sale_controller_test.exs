defmodule LitelistWeb.ForSaleControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Post

  @create_attrs %{contact_info: "some contact_info", description: "some description", price: 120.5, slug: "some slug", title: "some title"}
  @update_attrs %{contact_info: "some updated contact_info", description: "some updated description", price: 456.7, slug: "some updated slug", title: "some updated title"}
  @invalid_attrs %{contact_info: nil, description: nil, price: nil, slug: nil, title: nil}

  def fixture(:for_sale) do
    {:ok, for_sale} = Post.create_for_sale(@create_attrs)
    for_sale
  end

  describe "index" do
    test "lists all for_sales", %{conn: conn} do
      conn = get conn, for_sale_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing For sales"
    end
  end

  describe "new for_sale" do
    test "renders form", %{conn: conn} do
      conn = get conn, for_sale_path(conn, :new)
      assert html_response(conn, 200) =~ "New For sale"
    end
  end

  describe "create for_sale" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, for_sale_path(conn, :create), for_sale: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == for_sale_path(conn, :show, id)

      conn = get conn, for_sale_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show For sale"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, for_sale_path(conn, :create), for_sale: @invalid_attrs
      assert html_response(conn, 200) =~ "New For sale"
    end
  end

  describe "edit for_sale" do
    setup [:create_for_sale]

    test "renders form for editing chosen for_sale", %{conn: conn, for_sale: for_sale} do
      conn = get conn, for_sale_path(conn, :edit, for_sale)
      assert html_response(conn, 200) =~ "Edit For sale"
    end
  end

  describe "update for_sale" do
    setup [:create_for_sale]

    test "redirects when data is valid", %{conn: conn, for_sale: for_sale} do
      conn = put conn, for_sale_path(conn, :update, for_sale), for_sale: @update_attrs
      assert redirected_to(conn) == for_sale_path(conn, :show, for_sale)

      conn = get conn, for_sale_path(conn, :show, for_sale)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, for_sale: for_sale} do
      conn = put conn, for_sale_path(conn, :update, for_sale), for_sale: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit For sale"
    end
  end

  describe "delete for_sale" do
    setup [:create_for_sale]

    test "deletes chosen for_sale", %{conn: conn, for_sale: for_sale} do
      conn = delete conn, for_sale_path(conn, :delete, for_sale)
      assert redirected_to(conn) == for_sale_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, for_sale_path(conn, :show, for_sale)
      end
    end
  end

  defp create_for_sale(_) do
    for_sale = fixture(:for_sale)
    {:ok, for_sale: for_sale}
  end
end
