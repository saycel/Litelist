defmodule LitelistWeb.Utils.ExportUtils do
    @moduledoc """
    Utility functions for exporting data
    """
    alias Litelist.Repo
    alias Litelist.Auth.Neighbor

    @doc """
    build_posts_csv(neighbor)

    Runs a SQL query to return a csv of a neighbors posts
    """
    def build_posts_csv(%Neighbor{} = neighbor) do
        columns = "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"

        stream = Ecto.Adapters.SQL.stream(Repo, "COPY (SELECT #{columns} FROM posts WHERE neighbor_id=#{neighbor.id}) to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'")
       
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
        
        [columns | result.rows]
    end

    def build_my_flagged_posts_csv(%Neighbor{} = neighbor) do
        columns = "post_title,post_url,flag_type,flag_description,flag_status,admin_response\n"
        
        query = "COPY(SELECT posts.title, posts.url, flags.type, flags.description, flags.status, flags.admin_response
            FROM flags, posts
            WHERE flags.post_id = posts.id
            AND posts.neighbor_id = #{neighbor.id})
            to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'"

        stream = Ecto.Adapters.SQL.stream(Repo, query)
            
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
        
        [columns | result.rows]
    end

    def build_posts_i_flagged(%Neighbor{} = neighbor) do
        IO.inspect neighbor.id
        IO.inspect "(*******"
        id = 1
        columns = "post_title,post_url,flag_type,flag_description,flag_status,admin_response\n"
        
        query = "COPY(SELECT posts.title, posts.url, flags.type, flags.description, flags.status, flags.admin_response
            FROM flags, posts
            WHERE flags.post_id = posts.id
            AND flags.neighbor_id = #{neighbor.id})
            to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'"

        stream = Ecto.Adapters.SQL.stream(Repo, query)

        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
        
        [columns | result.rows]
    end

end