defmodule LitelistWeb.DashboardController do
    use LitelistWeb, :controller

    alias Litelist.Posts
    alias LitelistWeb.Utils.SharedUtils
    alias LitelistWeb.Utils.ExportUtils
    alias Litelist.Moderation

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
            |> redirect(to: dashboard_path(conn, :posts))
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

    def export_posts(conn, _params) do
        csv = ExportUtils.build_posts_csv(conn.assigns.current_neighbor)
     
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"MyPosts.csv\"")
        |> send_resp(200, csv)
    end

    def export_my_flagged_posts(conn, _params) do
        csv = ExportUtils.build_my_flagged_posts_csv(conn.assigns.current_neighbor)
     
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"MyFlaggedPosts.csv\"")
        |> send_resp(200, csv)
    end

    def export_posts_i_flagged(conn, _params) do
        csv = ExportUtils.build_posts_i_flagged(conn.assigns.current_neighbor)
     
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"MyFlaggedPosts.csv\"")
        |> send_resp(200, csv)
    end

    def my_flagged_posts(conn, _params) do
        flags = Moderation.list_my_flagged_posts(conn.assigns.current_neighbor)
        render(conn, "my_flagged_posts.html", flags: flags)
    end

    def posts_i_flagged(conn, _params) do
        flags = Moderation.list_flags_by_neighbor(conn.assigns.current_neighbor)
        IO.inspect flags
        render(conn, "posts_i_flagged.html", flags: flags)
    end

    defp unauthorized_redirect(conn) do
        conn
        |> put_flash(:error, "Unauthorized.")
        |> redirect(to: dashboard_path(conn, :posts))
    end
end