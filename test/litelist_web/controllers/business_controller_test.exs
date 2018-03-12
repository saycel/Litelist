defmodule LitelistWeb.BusinessControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Posts

  @create_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", location: "some location", slug: "some slug", title: "some title", type: "some type", url: "some url"}
  @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", location: "some updated location", slug: "some updated slug", title: "some updated title", type: "some updated type", url: "some updated url"}
  @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, location: nil, slug: nil, title: nil, type: nil, url: nil}

  def fixture(:business) do
    {:ok, business} = Posts.create_business(@create_attrs)
    business
  end

  describe "index" do
    test "lists all businesses", %{conn: conn} do
      conn = get conn, business_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Businesses"
    end
  end

  describe "new business" do
    test "renders form", %{conn: conn} do
      conn = get conn, business_path(conn, :new)
      assert html_response(conn, 200) =~ "New Business"
    end
  end

  describe "create business" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, business_path(conn, :create), business: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == business_path(conn, :show, id)

      conn = get conn, business_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Business"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, business_path(conn, :create), business: @invalid_attrs
      assert html_response(conn, 200) =~ "New Business"
    end
  end

  describe "edit business" do
    setup [:create_business]

    test "renders form for editing chosen business", %{conn: conn, business: business} do
      conn = get conn, business_path(conn, :edit, business)
      assert html_response(conn, 200) =~ "Edit Business"
    end
  end

  describe "update business" do
    setup [:create_business]

    test "redirects when data is valid", %{conn: conn, business: business} do
      conn = put conn, business_path(conn, :update, business), business: @update_attrs
      assert redirected_to(conn) == business_path(conn, :show, business)

      conn = get conn, business_path(conn, :show, business)
      assert html_response(conn, 200) =~ "some updated company_name"
    end

    test "renders errors when data is invalid", %{conn: conn, business: business} do
      conn = put conn, business_path(conn, :update, business), business: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Business"
    end
  end

  describe "delete business" do
    setup [:create_business]

    test "deletes chosen business", %{conn: conn, business: business} do
      conn = delete conn, business_path(conn, :delete, business)
      assert redirected_to(conn) == business_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, business_path(conn, :show, business)
      end
    end
  end

  defp create_business(_) do
    business = fixture(:business)
    {:ok, business: business}
  end
end
