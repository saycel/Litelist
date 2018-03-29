defmodule LitelistWeb.AdminController do
    use LitelistWeb, :controller
    plug :put_layout, "admin.html"   

    alias LitelistWeb.Utils.SharedUtils
    alias Litelist.Repo
    alias Litelist.Posts
    alias Litelist.Settings
    @permitted_params ["id", "site_name", "flag_count", "default_replyable"]

    def index(conn, _params) do
        render(conn, "index.html")
    end
    def moderate(conn, _params) do
        posts = Posts.list_posts
        render(conn, "moderate.html", posts: posts)
    end
    def moderation_information(conn, _params) do
        render(conn, "moderation_information.html")
    end

    def update_configuration(conn, %{"setting" => setting_params}) do
      setting = Settings.get_global_setting
      changeset = Settings.change_setting(setting)

      setting_params = setting_params
        |> SharedUtils.permitted_params(@permitted_params)

      case Settings.update_setting(setting, setting_params) do
        {:ok, setting} ->
            render(conn, "configure.html",setting: setting, changeset: changeset)
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "configure.html",setting: setting, changeset: changeset)
      end

    end
    def configure(conn, _params) do

        setting = Settings.get_global_setting
        # check admin permissions here
        changeset = Settings.change_setting(setting)

        render(conn, "configure.html",setting: setting, changeset: changeset)
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
        |> redirect(to: dashboard_path(conn, :posts))
    end

    defp build_csv(neighbor) do
        # credo:disable-for-lines:1
        # FIXME We will need a better create csv function in the future

        columns_array = ~w(id type url title description company_name contact_info start_date end_date start_time end_time location organization_name position_name price salary)
        columns = "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"
       
        stream = Ecto.Adapters.SQL.stream(Repo, "COPY (SELECT #{Enum.join(columns_array, ",")} FROM posts WHERE neighbor_id=#{neighbor.id}) to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'")
       
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
       
        [columns | result.rows]
    end
end