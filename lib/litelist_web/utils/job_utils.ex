defmodule LitelistWeb.Utils.JobUtils do
    @moduledoc """
    Job Utility functions
    """

    alias LitelistWeb.Utils.SharedUtils

    @permitted_params ["contact_info",
        "description",
        "salary",
        "title",
        "url",
        "start_date",
        "end_date",
        "company_name",
        "position_name",
        "location"
    ]

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