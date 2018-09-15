defmodule LitelistWeb.UtilsView do
    @moduledoc """
    Utility functions for views
    """

    @doc """
    Given a resource, this function creates a path that can be used for show, edit or delete.
    ## Examples

    iex> path_builder(for_sale)
    "/sales/:id"
    """
    def path_builder(resource) do
        case resource.type do
          "for_sale" -> "/sales/#{resource.id}"
          "job" -> "/jobs/#{resource.id}"
          "emergency_information" -> "/emergency_info/#{resource.id}"
          "business" -> "/businesses/#{resource.id}"
          "event" -> "/events/#{resource.id}"
          "traffic" -> "/traffics/#{resource.id}"
          "discussion" -> "/discussions/#{resource.id}"
        end
    end

    def get_color(type) do
        case type do
          "for_sale" -> "orange"
          "job" -> "ocean"
          "traffic" -> "brush"
          "emergency_information" -> "brush"
          "business" -> "lake"
          "event" -> "dark-pumpkin"
          "discussion" -> "brush"

        end
    end
    def get_color_array() do
      [
        {:'for sale', "orange", "/sales/new"},
        {:jobs, "ocean", "/jobs/new"},
        {:discussions, "brush", "/discussions/new"},
        {:business, "lake", "/businesses/new"},
        {:event, "dark-pumpkin", "/events/new"}
      ]
    end

    @doc """
    Given a post, this function creates a path to the flag post form
    ## Examples

    iex> flag_path_builder(for_sale)
    "/flags/new?post_id=:id"
    """
    def flag_path_builder(resource) do
        "/flags/new?post_id=#{resource.id}"
    end
end
