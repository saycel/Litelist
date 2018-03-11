defmodule LitelistWeb.Utils.SharedUtils do
    @moduledoc """
    ForSale Utility functions
    """
  
    @doc """
    slugify
    iex> slugify(nil)
    nil
    iex> slugify("Some String")
    "some-string"
    """

    def slugify(nil) do
        nil
    end
  
    def slugify(string) do
        string
        |> String.downcase
        |> String.replace(" ", "-")
    end

    @doc """
    add_generated_params()
    adds params like current_neighbor for create
    """
    def add_generated_params(params, conn, type, :create) do
        params
            |> add_neighbor_id(conn)
            |> add_slug()
            |> add_type(type)
    end
    
    @doc """
    add_generated_params()
    adds params like current_neighbor for update
    """
    def add_generated_params(params, :update) do
        params
            |> update_slug()
    end

    @doc """
    permission(neighbor, resource, type)
    tests if a resource was created by the neighbor, and if the given type matches the resource
    """
    def permission?(neighbor, resource, type) do
        if is_nil(neighbor) or is_nil(resource)do
            false
        end

        if neighbor.id == resource.neighbor_id and resource.type == type do
            true
        else
            false
        end
    end

    @doc """
    permitted_params(params, whitelist)
    Removes any non whitelisted attrs from params
    """
    def permitted_params(params, whitelist) do
        Enum.each params, fn key ->
            if key not in whitelist do
                Map.delete(params, key)
            end
        end
        params
    end

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
                "slug" => slugify(params["title"])
            },
            params
        )
    end

    defp update_slug(params) do
        params = Map.delete(params, "slug")
        Map.merge(
            %{
                "slug" => slugify(params["title"])
            },
            params
        )
    end

    defp add_type(params, type) do
        Map.merge(
            %{
                "type" => type
            },
            params
        )
    end
  end