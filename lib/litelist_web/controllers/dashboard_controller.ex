defmodule LitelistWeb.DashboardController do
    use LitelistWeb, :controller
    alias Litelist.Posts

    def index(conn, _params) do
        render(conn, "index.html")
    end

    def posts(conn, _params) do
        posts = Posts.list_posts_by_neighbor(conn.assigns.current_neighbor)
        render(conn, "posts.html", posts: posts)
    end

    def delete(conn, _params) do
        {total, _posts} = Posts.delete_all_by_neighbor(conn.assigns.current_neighbor)
        conn
            |> put_flash(:info, "All posts permanently deleted.")
            |> redirect(to: dashboard_path(conn, :index))
    end
end