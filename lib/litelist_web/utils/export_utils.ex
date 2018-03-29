defmodule LitelistWeb.Utils.ExportUtils do
    @moduledoc """
    Utility functions for exporting data
    """
    alias Litelist.Repo

    @columns "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"

    def build_posts_csv(neighbor) do
        # credo:disable-for-lines:1
        # FIXME We will need a better create csv function in the future

        columns_array = ~w(id type url title description company_name contact_info start_date end_date start_time end_time location organization_name position_name price salary)
        columns = "id,type,url,title,description,company_name,contact_info,start_date,end_date,start_time,end_time,location,organization_name,position_name,price,salary\n"
       
        stream = Ecto.Adapters.SQL.stream(Repo, "COPY (SELECT #{Enum.join(columns_array, ",")} FROM posts WHERE neighbor_id=#{neighbor.id}) to STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'")
       
        {:ok, [result|_t]} = Repo.transaction(fn -> Enum.to_list(stream) end)
       
        [@columns | result.rows]
    end

end