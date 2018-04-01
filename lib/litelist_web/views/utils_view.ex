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
        end
    end
end