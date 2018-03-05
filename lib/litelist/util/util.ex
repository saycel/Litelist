defmodule Litelist.Util do
    @moduledoc """
    A module to host utility functions.
    """

    def slugify(string = nil) do
        string
    end

    def slugify(string) do
        string
        |> String.downcase
        |> String.replace(" ", "-")
    end
end