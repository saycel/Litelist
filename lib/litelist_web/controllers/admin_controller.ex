defmodule LitelistWeb.AdminController do
    use LitelistWeb, :controller

    alias Litelist.Posts
  
    def index(conn, _params) do
      conn
        |> render("index.html")
    end

    def posts(conn, _params) do
        posts = Posts.list_posts()
        conn
          |> render("posts.html", posts: posts)
    end

    def settings(conn, _params) do
        conn
          |> render("settings.html")
    end
end
  