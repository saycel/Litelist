defmodule LitelistWeb.EmergencyInformationControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Factory
  alias Litelist.Auth.Guardian

  @create_attrs %{contact_info: "some contact_info", description: "some description", organization_name: "some organization_name", title: "some title", type: "emergency_information", url: "my-cool-url"}
  @update_attrs %{contact_info: "some updated contact_info", description: "some updated description", organization_name: "some updated organization_name", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{contact_info: nil, description: nil, organization_name: nil, title: nil, url: nil}

  setup do
    neighbor = Factory.insert(:neighbor)
    admin = Factory.insert(:neighbor, %{admin: true})
    emergency_information = Factory.insert(:emergency_information, neighbor_id: neighbor.id)
    not_my_emergency_information = Factory.insert(:emergency_information)
    not_a_emergency = Factory.insert(:job)
    {:ok, neighbor: neighbor, emergency_information: emergency_information, not_my_emergency_information: not_my_emergency_information, not_a_emergency: not_a_emergency, admin: admin}
  end

  describe "index" do
    test "lists all emergency_information", %{conn: conn} do
      conn = conn
        |> get(emergency_information_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Emergency information"
    end
  end

  describe "show" do
    test "shows an emergency info post if the type matches", %{conn: conn, emergency_information: emergency_information} do
      conn = conn
        |> get(emergency_information_path(conn, :show, emergency_information))

      assert html_response(conn, 200) =~ emergency_information.title
    end

    test "redirects to index if the type does not match", %{conn: conn, not_a_emergency: not_a_emergency} do
      conn = conn
        |> get(emergency_information_path(conn, :show, not_a_emergency))

        assert redirected_to(conn) == emergency_information_path(conn, :index)
    end
  end

  describe "new emergency_information" do
    test "renders form", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(emergency_information_path(conn, :new))
      
      assert html_response(conn, 200) =~ "Emergency Information Posting"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> get(emergency_information_path(conn, :new))
      
      assert response(conn, 401)
    end
  end
  
  describe "create emergency_information" do
    test "redirects to show when data is valid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(emergency_information_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == emergency_information_path(conn, :show, id)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, emergency_information_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Emergency information"
    end

    test "renders errors when data is invalid", %{conn: conn, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> post(emergency_information_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Emergency Information Posting"
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn} do
      conn = conn
        |> post(emergency_information_path(conn, :create), post: @create_attrs)
      assert response(conn, 401)
    end

    test "renders errors when url is not unique", %{conn: conn, neighbor: neighbor} do
      Factory.insert(:emergency_information, %{url: "my-cool-url"})

      conn = conn
        |> login_neighbor(neighbor)
        |> post(emergency_information_path(conn, :create), post: @create_attrs)
      assert html_response(conn, 200) =~ "Emergency Information Posting"
    end
  end

  describe "edit emergency_information" do
    test "renders form for editing chosen emergency_information", %{conn: conn, emergency_information: emergency_information, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(emergency_information_path(conn, :edit, emergency_information))
      assert html_response(conn, 200) =~ "Emergency Information Rules"
    end

    test "renders form for editing chosen emergency_information as an admin", %{conn: conn, emergency_information: emergency_information, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> get(emergency_information_path(conn, :edit, emergency_information))
      assert html_response(conn, 200) =~ "Emergency Information Rules"
    end

    test "redirects to index if emergency_information was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_emergency_information: not_my_emergency_information} do
      conn = conn
        |> login_neighbor(neighbor)
        |> get(emergency_information_path(conn, :edit, not_my_emergency_information))
      assert redirected_to(conn) == emergency_information_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, emergency_information: emergency_information} do
      conn = conn
        |> get(emergency_information_path(conn, :edit, emergency_information))
      
      assert response(conn, 401)
    end
  end

  describe "update emergency_information" do

    test "redirects when data is valid", %{conn: conn, emergency_information: emergency_information, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(emergency_information_path(conn, :update, emergency_information), post: @update_attrs)

      assert redirected_to(conn) == emergency_information_path(conn, :show, emergency_information)

      conn = conn
        |> recycle()
        |> login_neighbor(neighbor)

      conn = get conn, emergency_information_path(conn, :show, emergency_information)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "redirects when data is valid as an admin", %{conn: conn, emergency_information: emergency_information, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> put(emergency_information_path(conn, :update, emergency_information), post: @update_attrs)

      assert redirected_to(conn) == emergency_information_path(conn, :show, emergency_information)

      conn = conn
        |> recycle()
        |> login_neighbor(admin)

      conn = get conn, emergency_information_path(conn, :show, emergency_information)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, emergency_information: emergency_information, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(emergency_information_path(conn, :update, emergency_information), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "TITLE"
    end

    test "redirects to index if emergency_information was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_emergency_information: not_my_emergency_information} do
      conn = conn
        |> login_neighbor(neighbor)
        |> put(emergency_information_path(conn, :update, not_my_emergency_information), post: @invalid_attrs)

        assert redirected_to(conn) == emergency_information_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, emergency_information: emergency_information} do
      conn = conn
        |> put(emergency_information_path(conn, :update, emergency_information), emergency_information: @invalid_attrs)

      assert response(conn, 401)
    end
  end

  describe "delete emergency_information" do

    test "deletes chosen emergency_information", %{conn: conn, emergency_information: emergency_information, neighbor: neighbor} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(emergency_information_path(conn, :delete, emergency_information))

      assert redirected_to(conn) == emergency_information_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, emergency_information_path(conn, :show, emergency_information)
      end
    end

    test "deletes chosen emergency_information as an admin", %{conn: conn, emergency_information: emergency_information, admin: admin} do
      conn = conn
        |> login_neighbor(admin)
        |> delete(emergency_information_path(conn, :delete, emergency_information))

      assert redirected_to(conn) == emergency_information_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, emergency_information_path(conn, :show, emergency_information)
      end
    end

    test "redirects to index if emergency_information was not created by the neighbor", %{conn: conn, neighbor: neighbor, not_my_emergency_information: not_my_emergency_information} do
      conn = conn
        |> login_neighbor(neighbor)
        |> delete(emergency_information_path(conn, :delete, not_my_emergency_information))

        assert redirected_to(conn) == emergency_information_path(conn, :index)
    end

    test "unautorized 401 redirect if not logged in", %{conn: conn, emergency_information: emergency_information} do
      conn = conn
        |> delete(emergency_information_path(conn, :delete, emergency_information))

      assert response(conn, 401)
    end
  end

  defp login_neighbor(conn, neighbor) do
    {:ok, token, _} = Guardian.encode_and_sign(neighbor, %{}, token_type: :access)
    conn
      |> put_req_header("authorization", "bearer: " <> token)
  end
end
