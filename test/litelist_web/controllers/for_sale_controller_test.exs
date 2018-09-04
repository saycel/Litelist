# defmodule LitelistWeb.ForSaleControllerTest do
#   use LitelistWeb.ConnCase, async: true
#   import Phoenix.Controller

#   alias Litelist.Factory
#   alias Litelist.Auth.Guardian

#   @create_attrs %{"contact_info" => "some contact_info", "description" => "some description", "price" => 120.5, "title" => "some title", "url" => "my-cool-url"}
#   @update_attrs %{"contact_info" => "some updated contact_info", "description" => "some updated description", "price" => 456.7, "title" => "some updated title"}
#   @invalid_attrs %{"contact_info" => nil, "description" => nil, "price" => nil, "title" => nil}

#   describe "index" do
#     test "lists all for_sales", %{conn: conn} do
#       conn = conn
#         |> get(for_sale_path(conn, :index))

#       assert html_response(conn, 200)
#       assert view_template(conn) == "index.html"
#     end
#   end

#   describe "show" do
#     test "shows a for sale if the type matches", %{conn: conn} do
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> get(for_sale_path(conn, :show, for_sale))

#       assert html_response(conn, 200)
#       assert view_template(conn) == "show.html"
#     end

#     test "redirects to index if the type does not match", %{conn: conn} do
#       not_a_for_sale = Factory.insert(:job)
#       conn = conn
#         |> get(for_sale_path(conn, :show, not_a_for_sale))

#         assert redirected_to(conn) == for_sale_path(conn, :index)
#     end
#   end

#   describe "new for_sale" do
#     test "renders form", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       conn = conn
#         |> login_neighbor(neighbor)
#         |> get(for_sale_path(conn, :new))
      
#       assert html_response(conn, 200)
#       assert view_template(conn) == "new.html"
#     end

#     test "unautorized 401 redirect if not logged in", %{conn: conn} do
#       conn = conn
#         |> get(for_sale_path(conn, :new))
      
#       assert response(conn, 401)
#     end
#   end

#   describe "create for_sale" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> post(for_sale_path(conn, :create), post: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == for_sale_path(conn, :show, id)

#       conn = conn
#         |> recycle()
#         |> login_neighbor(neighbor)

#       conn = get conn, for_sale_path(conn, :show, id)
#       assert html_response(conn, 200)
#       assert view_template(conn) == "show.html"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       conn = conn
#         |> login_neighbor(neighbor)
#         |> post(for_sale_path(conn, :create), post: @invalid_attrs)
#       assert html_response(conn, 200)
#       assert view_template(conn) == "new.html"
#     end

#     test "unautorized 401 redirect if not logged in", %{conn: conn} do
#       conn = conn
#         |> post(for_sale_path(conn, :create), job: @create_attrs)
#       assert response(conn, 401)
#     end

#     test "renders errors when url is not unique", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       Factory.insert(:for_sale, %{url: "my-cool-url"})
#       conn = conn
#         |> login_neighbor(neighbor)
#         |> post(for_sale_path(conn, :create), post: @create_attrs)
#       assert html_response(conn, 200)
#       assert view_template(conn) == "new.html"
#     end
#   end

#   describe "edit for_sale" do
#     test "renders form for editing chosen for_sale", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       for_sale = Factory.insert(:for_sale, %{neighbor_id: neighbor.id})

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> get(for_sale_path(conn, :edit, for_sale))
#       assert html_response(conn, 200)
#       assert view_template(conn) == "edit.html"
#     end

#     test "renders form for editing chosen for_sale as an admin", %{conn: conn} do
#       admin = Factory.insert(:admin)
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(admin)
#         |> get(for_sale_path(conn, :edit, for_sale))
#       assert html_response(conn, 200)
#       assert view_template(conn) == "edit.html"
#     end

#     test "redirects to index if for_sale was not created by the neighbor", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       not_my_for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> get(for_sale_path(conn, :edit, not_my_for_sale))
#       assert redirected_to(conn) == for_sale_path(conn, :index)
#     end

#     test "unautorized 401 redirect if not logged in", %{conn: conn} do
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> get(for_sale_path(conn, :edit, for_sale))
      
#       assert response(conn, 401)
#     end
#   end


#   describe "update for_sale" do

#     test "redirects when data is valid", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       for_sale = Factory.insert(:for_sale, %{neighbor_id: neighbor.id})

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> put(for_sale_path(conn, :update, for_sale), post: @update_attrs)

#       assert redirected_to(conn) == for_sale_path(conn, :show, for_sale)

#       conn = conn
#         |> recycle()
#         |> login_neighbor(neighbor)

#       conn = get conn, for_sale_path(conn, :show, for_sale)
#       assert html_response(conn, 200)
#       assert view_template(conn) == "show.html"
#     end

#     test "redirects when data is valid as an admin", %{conn: conn} do
#       admin = Factory.insert(:admin)
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(admin)
#         |> put(for_sale_path(conn, :update, for_sale), post: @update_attrs)

#       assert redirected_to(conn) == for_sale_path(conn, :show, for_sale)

#       conn = conn
#         |> recycle()
#         |> login_neighbor(admin)

#       conn = get conn, for_sale_path(conn, :show, for_sale)
#       assert html_response(conn, 200)
#       assert view_template(conn) == "show.html"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       for_sale = Factory.insert(:for_sale, %{neighbor_id: neighbor.id})

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> put(for_sale_path(conn, :update, for_sale), post: @invalid_attrs)

#       assert html_response(conn, 200)
#       assert view_template(conn) == "edit.html"
#     end

#     test "redirects to index if for_sale was not created by the neighbor", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       not_my_for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> put(for_sale_path(conn, :update, not_my_for_sale), post: @invalid_attrs)

#         assert redirected_to(conn) == for_sale_path(conn, :index)
#     end

#     test "unautorized 401 redirect if not logged in", %{conn: conn} do
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> put(for_sale_path(conn, :update, for_sale), for_sale: @invalid_attrs)

#       assert response(conn, 401)
#     end
#   end

#   describe "delete for_sale" do

#     test "deletes chosen for_sale", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       for_sale = Factory.insert(:for_sale, %{neighbor_id: neighbor.id})

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> delete(for_sale_path(conn, :delete, for_sale))

#       assert redirected_to(conn) == for_sale_path(conn, :index)
#       assert_error_sent 404, fn ->
#         get conn, for_sale_path(conn, :show, for_sale)
#       end
#     end

#     test "deletes chosen for_sale as an admin", %{conn: conn} do
#       admin = Factory.insert(:admin)
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(admin)
#         |> delete(for_sale_path(conn, :delete, for_sale))

#       assert redirected_to(conn) == for_sale_path(conn, :index)
#       assert_error_sent 404, fn ->
#         get conn, for_sale_path(conn, :show, for_sale)
#       end
#     end


#     test "redirects to index if for_sale was not created by the neighbor", %{conn: conn} do
#       neighbor = Factory.insert(:neighbor)
#       not_my_for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> login_neighbor(neighbor)
#         |> delete(for_sale_path(conn, :delete, not_my_for_sale))

#         assert redirected_to(conn) == for_sale_path(conn, :index)
#     end

#     test "unautorized 401 redirect if not logged in", %{conn: conn} do
#       for_sale = Factory.insert(:for_sale)

#       conn = conn
#         |> delete(for_sale_path(conn, :delete, for_sale))

#       assert response(conn, 401)
#     end
#   end

#   defp login_neighbor(conn, neighbor) do
#     {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
#     conn
#       |> put_req_header("authorization", "bearer: " <> token)
#   end
# end
