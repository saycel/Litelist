defmodule LitelistWeb.SearchControllerTest do
  use LitelistWeb.ConnCase, async: true
  import Phoenix.Controller

  alias Litelist.Factory

  alias LitelistWeb.Router.Helpers, as: Routes

  setup do
    title = "unlikelytitle"
    unsearched_title = "unsearchedtitle"
    Factory.insert(:job, %{title: title})
    Factory.insert(:job, %{title: unsearched_title})
    Factory.insert(:job)

    {:ok, attrs: %{title: title, unsearched_title: unsearched_title}}
  end

  describe "index" do
    test "shows the search page", %{conn: conn} do
      conn =
        conn
        |> get(Routes.search_path(conn, :index))

      assert html_response(conn, 200)
      assert view_template(conn) == "index.html"
    end

    test "shows the search page with a query and the correct results", %{conn: conn, attrs: attrs} do
        conn =
          conn
          |> get(Routes.search_path(conn, :index, %{search: attrs.title}))
  
        assert html_response(conn, 200) =~ attrs.title
        refute html_response(conn, 200) =~ attrs.unsearched_title
      end

      test "shows the search page without a query and no posts", %{conn: conn, attrs: attrs} do
        conn =
          conn
          |> get(Routes.search_path(conn, :index))
  
        refute html_response(conn, 200) =~ attrs.title
        refute html_response(conn, 200) =~ attrs.unsearched_title
        assert html_response(conn, 200) =~ "Add a search term"
      end
  end
end
