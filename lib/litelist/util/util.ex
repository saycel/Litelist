defmodule Litelist.Util do
    @moduledoc """
    A module to host utility functions.
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
end