defmodule Litelist.Plugs.EnsureAdmin do
    @moduledoc """
    Plug adds @current_neighbor to conn. @current_neighbor is nil if no one is signed in.
    """

    def init(opts), do: opts
  
    def call(conn, _opts) do
      current_neighbor = Guardian.Plug.current_resource(conn)
      if !is_nil(current_neighbor) and current_neighbor.admin do
        conn
      else
        conn
            |> Phoenix.Controller.put_flash(:error, "Unauthorized.")
            |> Phoenix.Controller.redirect(to: "/")
      end
    end
end