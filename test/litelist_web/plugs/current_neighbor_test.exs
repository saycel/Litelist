defmodule LitelistWeb.Plugs.CurrentNeighborTest do
    use LitelistWeb.ConnCase, async: true
    alias Litelist.Plugs.CurrentNeighbor

    describe "current neighbor plug" do
        test "init" do
            opts = %{}        
            assert CurrentNeighbor.init(opts) == opts
        end

        test "if a neighbor is not signed in with guardian, returns nil" do
            opts = %{}
            conn = build_conn()
                |> CurrentNeighbor.call(opts)

            assert conn.assigns.current_neighbor == nil
        end
    end
end