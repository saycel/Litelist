defmodule LitelistWeb.BusinessControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", location: "some location", slug: "some slug", title: "some title", type: "business", url: "my-cool-url"}
  @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", location: "some updated location", slug: "some updated slug", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, location: nil, slug: nil, title: nil, type: nil, url: nil}

  setup do
    neighbor = Factory.insert(:neighbor)
    admin = Factory.insert(:neighbor, %{admin: true})
    business = Factory.insert(:business, neighbor_id: neighbor.id)
    not_my_business = Factory.insert(:business)
    {:ok, neighbor: neighbor, business: business, not_my_business: not_my_business, admin: admin}
  end

  describe "index" do
    test "lists all businesss", %{conn: conn} do
      conn = conn
        |> get(business_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Business"
    end
  end

  describe "new business" do
    test "renders form", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(business_path(conn, :new))
      
      assert html_response(conn, 200) =~ "New Business"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(business_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create business" do
    test "redirects to show when data is valid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(business_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == business_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, business_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Business"
    end

    test "renders errors when data is invalid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(business_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Business"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(business_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end

    test "renders errors when url is not unique", %{conn: conn, neighbor: neighbor} do
      Factory.insert(:business, %{url: "my-cool-url"})

      conn = conn
        |> login_neighbor(neighbor)
        |> post(business_path(conn, :create), post: @create_attrs)
      assert html_response(conn, 200) =~ "New Business"
    end
  end

  describe "edit business" do
    test "renders form for editing chosen business", %{conn: conn, business: business, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(business_path(conn, :edit, business))
      assert html_response(conn, 200) =~ "Edit Business"
    end

    test "renders form for editing chosen business as an admin", %{conn: conn, business: business, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> get(business_path(conn, :edit, business))
      assert html_response(conn, 200) =~ "Edit Business"
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_business: not_my_business} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(business_path(conn, :edit, not_my_business))
      assert redirected_to(conn) == business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, business: business} do
      conn = conn
        |> get(business_path(conn, :edit, business))
      
      assert response(conn, 401)
    end
  end

  describe "update business" do

    test "redirects when data is valid", %{conn: conn, business: business, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(business_path(conn, :update, business), post: @update_attrs)

      assert redirected_to(conn) == business_path(conn, :show, business)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, business_path(conn, :show, business)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "redirects when data is valid as an admin", %{conn: conn, business: business, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(business_path(conn, :update, business), post: @update_attrs)

      assert redirected_to(conn) == business_path(conn, :show, business)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, business_path(conn, :show, business)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, business: business, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(business_path(conn, :update, business), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Business"
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_business: not_my_business} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(business_path(conn, :update, not_my_business), post: @invalid_attrs)

        assert redirected_to(conn) == business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, business: business} do
      conn = conn
        |> put(business_path(conn, :update, business), business: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete business" do

    test "deletes chosen business", %{conn: conn, business: business, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(business_path(conn, :delete, business))

      assert redirected_to(conn) == business_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, business_path(conn, :show, business)
      end
    end

    test "deletes chosen business as an admin", %{conn: conn, business: business, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> delete(business_path(conn, :delete, business))

      assert redirected_to(conn) == business_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, business_path(conn, :show, business)
      end
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_business: not_my_business} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(business_path(conn, :delete, not_my_business))

        assert redirected_to(conn) == business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, business: business} do
      conn = conn
        |> delete(business_path(conn, :delete, business))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
