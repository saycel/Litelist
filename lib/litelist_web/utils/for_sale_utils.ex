defmodule LitelistWeb.Utils.ForSaleUtils do
    @moduledoc """
    ForSale Utility functions
    """

    alias LitelistWeb.Utils.SharedUtils

    @for_sale_type "for_sale"
    @permitted_params ["contact_info", "description", "price", "slug", "title", "url"]


    @doc """
    add_neighbor_id()
    adds a neighbor id from the conn, to the params Map
    """
    def add_neighbor_id(params, conn) do
        Map.merge(
            %{
                "neighbor_id" => conn.assigns.current_neighbor.id
            },
            params
        )
    end
    
    @doc """
    add_slug()
    adds a slug attribute to the params Map
    """
    def add_slug(params) do
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    @doc """
    update_slug()
    removes existing slug attribute and generates a new slug and adds it to the params Map
    """
    def update_slug(params) do
        params = Map.delete(params, "slug")
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    @doc """
    add_type()
    adds a type attribute to the params Map
    """
    def add_type(params) do
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
end