defmodule LitelistWeb.AdminController do
    use LitelistWeb, :controller
  
    def index(conn, _params) do
      conn
        |> render("index.html")
    end
end
  