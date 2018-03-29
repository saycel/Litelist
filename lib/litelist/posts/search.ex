defmodule Litelist.Posts.Search do
    @moduledoc """
    Implementation of the full-text user search for posts
    """
  
    import Ecto.Query

    @spec run(Ecto.Query.t(), any()) :: Ecto.Query.t()
    def run(query, search_term) do
        where(
          query,
          fragment(
            "to_tsvector('english', title || ' ' || location || ' ' || coalesce(description, ' ')) @@
            to_tsquery(?)",
            ^prefix_search(search_term)
          )
        )
    end

    defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"
end


  
  