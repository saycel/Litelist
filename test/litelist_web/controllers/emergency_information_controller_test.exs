defmodule LitelistWeb.EmergencyInformationControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Posts

  @create_attrs %{contact_info: "some contact_info", description: "some description", organization_name: "some organization_name", slug: "some slug", title: "some title", type: "some type", url: "some url"}
  @update_attrs %{contact_info: "some updated contact_info", description: "some updated description", organization_name: "some updated organization_name", slug: "some updated slug", title: "some updated title", type: "some updated type", url: "some updated url"}
  @invalid_attrs %{contact_info: nil, description: nil, organization_name: nil, slug: nil, title: nil, type: nil, url: nil}

  def fixture(:emergency_information) do
    {:ok, emergency_information} = Posts.create_emergency_information(@create_attrs)
    emergency_information
  end

  describe "index" do
    test "lists all emergency_information", %{conn: conn} do
      conn = get conn, emergency_information_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Emergency information"
    end
  end

  describe "new emergency_information" do
    test "renders form", %{conn: conn} do
      conn = get conn, emergency_information_path(conn, :new)
      assert html_response(conn, 200) =~ "New Emergency information"
    end
  end

  describe "create emergency_information" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, emergency_information_path(conn, :create), emergency_information: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == emergency_information_path(conn, :show, id)

      conn = get conn, emergency_information_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Emergency information"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, emergency_information_path(conn, :create), emergency_information: @invalid_attrs
      assert html_response(conn, 200) =~ "New Emergency information"
    end
  end

  describe "edit emergency_information" do
    setup [:create_emergency_information]

    test "renders form for editing chosen emergency_information", %{conn: conn, emergency_information: emergency_information} do
      conn = get conn, emergency_information_path(conn, :edit, emergency_information)
      assert html_response(conn, 200) =~ "Edit Emergency information"
    end
  end

  describe "update emergency_information" do
    setup [:create_emergency_information]

    test "redirects when data is valid", %{conn: conn, emergency_information: emergency_information} do
      conn = put conn, emergency_information_path(conn, :update, emergency_information), emergency_information: @update_attrs
      assert redirected_to(conn) == emergency_information_path(conn, :show, emergency_information)

      conn = get conn, emergency_information_path(conn, :show, emergency_information)
      assert html_response(conn, 200) =~ "some updated contact_info"
    end

    test "renders errors when data is invalid", %{conn: conn, emergency_information: emergency_information} do
      conn = put conn, emergency_information_path(conn, :update, emergency_information), emergency_information: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Emergency information"
    end
  end

  describe "delete emergency_information" do
    setup [:create_emergency_information]

    test "deletes chosen emergency_information", %{conn: conn, emergency_information: emergency_information} do
      conn = delete conn, emergency_information_path(conn, :delete, emergency_information)
      assert redirected_to(conn) == emergency_information_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, emergency_information_path(conn, :show, emergency_information)
      end
    end
  end

  defp create_emergency_information(_) do
    emergency_information = fixture(:emergency_information)
    {:ok, emergency_information: emergency_information}
  end
end
