defmodule LitelistWeb.Utils.ForSaleUtils do
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
    # TODO We may want to set a max length or do
    # some work to ensure a unique slug in the future.

    alias LitelistWeb.Utils.SharedUtils

    @for_sale_type "for_sale"
    @permitted_params ["contact_info", "description", "price", "slug", "title", "url"]

    def add_neighbor_id(params, conn) do
        Map.merge(
            %{
                "neighbor_id" => conn.assigns.current_neighbor.id
            },
            params
        )
    end
    
    def add_slug(params) do
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    def update_slug(params) do
        params = Map.delete(params, "slug")
        Map.merge(
            %{
                "slug" => SharedUtils.slugify(params["title"])
            },
            params
        )
    end

    def add_type(params) do
        Map.merge(
            %{
                "type" => @for_sale_type
            },
            params
        )
    end

    def permitted_params(params) do
        Enum.each params, fn key ->
            if key not in @permitted_params do
                Map.delete(params, key)
            end
        end
        params
    end
end