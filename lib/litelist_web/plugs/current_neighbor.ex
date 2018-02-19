defmodule Litelist.Plugs.CurrentNeighbor do
    def init(opts), do: opts
  
    def call(conn, _opts) do
      current_neighbor = Guardian.Plug.current_resource(conn)
      if current_neighbor do
        Plug.Conn.assign(conn, :current_neighbor, current_neighbor)
      else
        Plug.Conn.assign(conn, :current_neighbor, nil)
      end
    end
  end