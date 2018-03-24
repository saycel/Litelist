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
end