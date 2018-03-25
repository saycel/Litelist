defmodule LitelistWeb.DashboardController do
    use LitelistWeb, :controller
    alias Litelist.Posts
    alias LitelistWeb.Utils.SharedUtils
    alias Litelist.Repo

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

    def export_posts(conn, _params) do
        csv = build_csv(conn.assigns.current_neighbor)
     
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"MyPosts.csv\"")
        |> send_resp(200, csv)
    end

    defp unauthorized_redirect(conn) do
        conn
        |> put_flash(:error, "Unauthorized.")
        |> redirect(to: dashboard_path(conn, :index))
    end

    defp build_csv(neighbor) do 
        columns_array = ~w(id type url title description company_name contact_info start_date end_date start_time end_time location organization_name position_name price salary)
        columns = "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"
       
        stream = Ecto.Adapters.SQL.stream(Repo, "COPY (SELECT #{Enum.join(columns_array, ",")} FROM posts WHERE neighbor_id=#{neighbor.id}) to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'")
       
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
       
        [columns | result.rows]
    end
end