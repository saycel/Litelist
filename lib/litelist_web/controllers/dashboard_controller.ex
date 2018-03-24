defmodule LitelistWeb.DashboardController do
    use LitelistWeb, :controller
    alias Litelist.Posts
    alias LitelistWeb.Utils.SharedUtils

    def index(conn, _params) do
        render(conn, "index.html")
    end

    def posts(conn, _params) do
        posts = Posts.list_posts_by_neighbor(conn.assigns.current_neighbor)
        render(conn, "posts.html", posts: posts)
    end

    def delete_all(conn, _params) do
        {_total, _posts} = Posts.delete_all_by_neighbor(conn.assigns.current_neighbor)
        conn
            |> put_flash(:info, "All posts permanently deleted.")
            |> redirect(to: dashboard_path(conn, :index))
    end

    def delete(conn, %{"id" => id}) do
        job = Posts.get_post!(id)
        if SharedUtils.permission?(conn.assigns.current_neighbor, job, job.type) do
          {:ok, _job} = Posts.delete_post(job)
    
          conn
          |> put_flash(:info, "Job deleted successfully.")
          |> redirect(to: dashboard_path(conn, :posts))
        else
          unauthorized_redirect(conn)
        end
    end

    defp unauthorized_redirect(conn) do
        conn
        |> put_flash(:error, "Unauthorized.")
        |> redirect(to: dashboard_path(conn, :index))
    end
end