defmodule LitelistWeb.Utils.ExportUtils do
    @moduledoc """
    Utility functions for exporting data
    """
    alias Litelist.Repo

    def build_posts_csv(neighbor) do
        columns = "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"

        stream = Ecto.Adapters.SQL.stream(Repo, "COPY (SELECT #{columns} FROM posts WHERE neighbor_id=#{neighbor.id}) to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'")
       
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
        
        [columns | result.rows]
    end

end