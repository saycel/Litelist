defmodule LitelistWeb.SearchController do
    use LitelistWeb, :controller
  
    alias Litelist.Posts

    def index(conn, %{"search" => search_term}) do
        posts = Posts.list_posts_by_search_term(search_term)
        render(conn, "index.html", posts: posts)
    end
    def index(conn, _params) do
        render(conn, "index.html", posts: [])
    end
end