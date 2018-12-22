defmodule LitelistWeb.BusinessControllerTest do
  use LitelistWeb.ConnCase, async: true
  import Phoenix.Controller

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  alias LitelistWeb.Router.Helpers, as: Routes

  @create_attrs %{company_name: "some company_name", contact_info: "some contact_info", description: "some description", location: "some location", slug: "some slug", title: "some title", type: "business", url: "my-cool-url"}
  @update_attrs %{company_name: "some updated company_name", contact_info: "some updated contact_info", description: "some updated description", location: "some updated location", slug: "some updated slug", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{company_name: nil, contact_info: nil, description: nil, location: nil, slug: nil, title: nil, type: nil, url: nil}

  describe "index" do
    test "lists all businesss", %{conn: conn} do
      conn = conn
        |> get(Routes.business_path(conn, :index))

      assert html_response(conn, 200)
      assert view_template(conn) == "index.html"
    end
  end

  describe "show" do
    test "shows a business if the type matches", %{conn: conn} do
      business = Factory.insert(:business)

      conn = conn
        |> get(Routes.business_path(conn, :show, business))

      assert html_response(conn, 200)
      assert view_template(conn) == "show.html"
    end

    test "redirects to index if the type does not match", %{conn: conn} do
      not_a_business = Factory.insert(:job)

      conn = conn
        |> get(Routes.business_path(conn, :show, not_a_business))

        assert redirected_to(conn) == Routes.business_path(conn, :index)
    end
  end

  describe "new business" do
    test "renders form", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)

      conn = conn
        |> login_neighbor(neighbor)
        |> get(Routes.business_path(conn, :new))
      
      assert html_response(conn, 200)
      assert view_template(conn) == "new.html"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(Routes.business_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create business" do
    test "redirects to show when data is valid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)

      conn = conn
        |> login_neighbor(neighbor)
        |> post(Routes.business_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.business_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, Routes.business_path(conn, :show, id)
      assert html_response(conn, 200)
      assert view_template(conn) == "show.html"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)

      conn = conn
        |> login_neighbor(neighbor)
        |> post(Routes.business_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200)
      assert view_template(conn) == "new.html"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(Routes.business_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end

    # test "renders errors when url is not unique", %{conn: conn} do
    #   neighbor = Factory.insert(:neighbor)
    #   Factory.insert(:business, %{url: "my-cool-url"})

    #   conn = conn
    #     |> login_neighbor(neighbor)
    #     |> post(Routes.business_path(conn, :create), post: @create_attrs)
    #   assert html_response(conn, 200)
    #   assert view_template(conn) == "new.html"
    # end
  end

  describe "edit business" do
    test "renders form for editing chosen business", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      business = Factory.insert(:business, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> get(Routes.business_path(conn, :edit, business))
      assert html_response(conn, 200)
      assert view_template(conn) == "edit.html"
    end

    test "renders form for editing chosen business as an admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(admin)
        |> get(Routes.business_path(conn, :edit, business))
      assert html_response(conn, 200)
      assert view_template(conn) == "edit.html"
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      not_my_business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(neighbor)
        |> get(Routes.business_path(conn, :edit, not_my_business))
      assert redirected_to(conn) == Routes.business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      business = Factory.insert(:business)

      conn = conn
        |> get(Routes.business_path(conn, :edit, business))
      
      assert response(conn, 401)
    end
  end

  describe "update business" do

    test "redirects when data is valid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      business = Factory.insert(:business, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> put(Routes.business_path(conn, :update, business), post: @update_attrs)

      assert redirected_to(conn) == Routes.business_path(conn, :show, business)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, Routes.business_path(conn, :show, business)
      assert html_response(conn, 200)
      assert view_template(conn) == "show.html"
    end

    test "redirects when data is valid as an admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(admin)
        |> put(Routes.business_path(conn, :update, business), post: @update_attrs)

      assert redirected_to(conn) == Routes.business_path(conn, :show, business)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, Routes.business_path(conn, :show, business)
      assert html_response(conn, 200)
      assert view_template(conn) == "show.html"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      business = Factory.insert(:business, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> put(Routes.business_path(conn, :update, business), post: @invalid_attrs)

      assert html_response(conn, 200)
      assert view_template(conn) == "edit.html"
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      not_my_business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(neighbor)
        |> put(Routes.business_path(conn, :update, not_my_business), post: @invalid_attrs)

        assert redirected_to(conn) == Routes.business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      business = Factory.insert(:business)

      conn = conn
        |> put(Routes.business_path(conn, :update, business), business: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete business" do

    test "deletes chosen business", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      business = Factory.insert(:business, %{neighbor_id: neighbor.id})

      conn = conn
        |> login_neighbor(neighbor)
        |> delete(Routes.business_path(conn, :delete, business))

      assert redirected_to(conn) == Routes.business_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.business_path(conn, :show, business)
      end
    end

    test "deletes chosen business as an admin", %{conn: conn} do
      admin = Factory.insert(:admin)
      business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(admin)
        |> delete(Routes.business_path(conn, :delete, business))

      assert redirected_to(conn) == Routes.business_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.business_path(conn, :show, business)
      end
    end

    test "redirects to index if business was not created by the neighbor", %{conn: conn} do
      neighbor = Factory.insert(:neighbor)
      not_my_business = Factory.insert(:business)

      conn = conn
        |> login_neighbor(neighbor)
        |> delete(Routes.business_path(conn, :delete, not_my_business))

        assert redirected_to(conn) == Routes.business_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      business = Factory.insert(:business)

      conn = conn
        |> delete(Routes.business_path(conn, :delete, business))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
