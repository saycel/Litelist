defmodule LitelistWeb.AdminController do
    use LitelistWeb, :controller
    alias Litelist.Moderation
    alias Litelist.Posts
    alias Litelist.Settings.SettingsDatabase
    plug :put_layout, "admin.html"


    def index(conn, _params) do
      conn
        |> render("index.html")
    end

    def rules(conn, _params) do
        render(conn, "moderation_rules.html")
    end
    def moderation(conn, _params) do
        flags = Moderation.list_flags()
        render(conn, "moderation.html", flags: flags)
    end
    def posts(conn, _params) do
        posts = Posts.list_posts()
        conn
          |> render("posts.html", posts: posts)
    end

    def settings(conn, _params) do
        settings = SettingsDatabase.get_settings().map
        conn
          |> render("settings.html", settings: settings)
    end

    def update_settings(conn, %{"name" => name, "max_flagged_posts" => max_flagged_posts, "allow_replies" => allow_replies}) do
        SettingsDatabase.update_settings(%{
            name: name,
            max_flagged_posts: max_flagged_posts,
            allow_replies: String.to_existing_atom(allow_replies)
        })
        conn
            |> put_flash(:info, "Settings updated.")
            |> redirect(to: admin_path(conn, :settings))
    end
end 
  