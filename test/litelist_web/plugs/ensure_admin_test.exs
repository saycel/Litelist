defmodule LitelistWeb.Plugs.EnsureAdminTest do
    use LitelistWeb.ConnCase
    alias Litelist.Plugs.EnsureAdmin

    describe "current neighbor plug" do
        test "init" do
            opts = %{}        
            assert EnsureAdmin.init(opts) == opts
        end

        test "if the current user is not signed in with admin privileges, halts with a 401 status" do
            opts = %{}
            conn = build_conn()
                |> EnsureAdmin.call(opts)

            assert assert conn.status == 401
        end
    end
end