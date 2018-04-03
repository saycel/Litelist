defmodule LitelistWeb.FlagControllerTest do
  use LitelistWeb.ConnCase

  alias Litelist.Moderation

  @create_attrs %{admin_response: "some admin_response", description: "some description", status: "some status", type: "some type"}
  @update_attrs %{admin_response: "some updated admin_response", description: "some updated description", status: "some updated status", type: "some updated type"}
  @invalid_attrs %{admin_response: nil, description: nil, status: nil, type: nil}

  def fixture(:flag) do
    {:ok, flag} = Moderation.create_flag(@create_attrs)
    flag
  end

  describe "index" do
    test "lists all flags", %{conn: conn} do
      conn = get conn, flag_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Flags"
    end
  end

  describe "new flag" do
    test "renders form", %{conn: conn} do
      conn = get conn, flag_path(conn, :new)
      assert html_response(conn, 200) =~ "New Flag"
    end
  end

  describe "create flag" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, flag_path(conn, :create), flag: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == flag_path(conn, :show, id)

      conn = get conn, flag_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Flag"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, flag_path(conn, :create), flag: @invalid_attrs
      assert html_response(conn, 200) =~ "New Flag"
    end
  end

  describe "edit flag" do
    setup [:create_flag]

    test "renders form for editing chosen flag", %{conn: conn, flag: flag} do
      conn = get conn, flag_path(conn, :edit, flag)
      assert html_response(conn, 200) =~ "Edit Flag"
    end
  end

  describe "update flag" do
    setup [:create_flag]

    test "redirects when data is valid", %{conn: conn, flag: flag} do
      conn = put conn, flag_path(conn, :update, flag), flag: @update_attrs
      assert redirected_to(conn) == flag_path(conn, :show, flag)

      conn = get conn, flag_path(conn, :show, flag)
      assert html_response(conn, 200) =~ "some updated admin_response"
    end

    test "renders errors when data is invalid", %{conn: conn, flag: flag} do
      conn = put conn, flag_path(conn, :update, flag), flag: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Flag"
    end
  end

  describe "delete flag" do
    setup [:create_flag]

    test "deletes chosen flag", %{conn: conn, flag: flag} do
      conn = delete conn, flag_path(conn, :delete, flag)
      assert redirected_to(conn) == flag_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, flag_path(conn, :show, flag)
      end
    end
  end

  defp create_flag(_) do
    flag = fixture(:flag)
    {:ok, flag: flag}
  end
end
