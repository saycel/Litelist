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

    def permission?(neighbor, resource) do
        if neighbor.id == resource.neighbor_id and resource.type == "for_sale" do
            true
        else
            false
        end
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

    def add_generated_params44(params, conn, type, :create) do
        params
            |> add_neighbor_id(conn)
            |> add_slug()
            |> add_type(type)
    end

    def add_generated_params44(params, :update) do
        params
            |> update_slug()
    end
  end