defmodule LitelistWeb.Utils.ForSaleUtils do
    @moduledoc """
    ForSale Utility functions
    """

    alias LitelistWeb.Utils.SharedUtils

    @for_sale_type "for_sale"
    @permitted_params ["contact_info", "description", "price", "slug", "title", "url"]

    defp add_neighbor_id(params, conn) do
        Map.merge(
            %{
                "neighbor_id" => conn.assigns.current_neighbor.id
            },
            params
        )
    end
    
    defp add_slug(params) do
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    defp update_slug(params) do
        params = Map.delete(params, "slug")
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    defp add_type(params) do
        Map.merge(
            %{
                "type" => @for_sale_type
            },
            params
        )
    end

    @doc """
    permitted_params()
    removes any non-white-listed params
    """
    def permitted_params(params) do
        Enum.each params, fn key ->
            if key not in @permitted_params do
                Map.delete(params, key)
            end
        end
        params
    end

    @doc """
    add_generated_params()
    adds params like current_neighbor for create
    """
    def add_generated_params(params, conn, :create) do
        params
            |> add_neighbor_id(conn)
            |> add_slug()
            |> add_type()
    end

    @doc """
    add_generated_params()
    adds params like current_neighbor for update
    """
    def add_generated_params(params, :update) do
        params
            |> update_slug()
    end
end