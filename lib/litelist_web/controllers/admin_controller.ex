defmodule LitelistWeb.AdminController do
    use LitelistWeb, :controller
    alias Litelist.Posts
    alias Litelist.Settings


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
        settings = Settings.get_settings()
        conn
          |> render("settings.html", settings: settings)
    end

    def update_settings(conn, %{"name" => name, "max_flagged_posts" => max_flagged_posts, "allow_replies" => allow_replies}) do
        Settings.new_settings(%{
            name: name,
            max_flagged_posts: max_flagged_posts,
            allow_replies: String.to_existing_atom(allow_replies),
            neighbor_id: conn.assigns.current_neighbor.id
        })
        conn
            |> put_flash(:info, "Settings updated.")
            |> redirect(to: Routes.admin_path(conn, :settings))
    end
end 
  