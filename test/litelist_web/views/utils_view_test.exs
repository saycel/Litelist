defmodule LitelistWeb.UtilsViewTest do
    use LitelistWeb.ConnCase, async: true

    alias LitelistWeb.UtilsView
    alias Litelist.Factory

    test "path_builder/1 returns expected values" do
        for_sale = %{type: "for_sale", id: 1}
        job = %{type: "job", id: 1}
        emergency_information = %{type: "emergency_information", id: 1}
        business = %{type: "business", id: 1}
        event = %{type: "event", id: 1}

        assert UtilsView.path_builder(for_sale) == "/sales/1"
        assert UtilsView.path_builder(job) == "/jobs/1"
        assert UtilsView.path_builder(emergency_information) == "/emergency_info/1"
        assert UtilsView.path_builder(business) == "/businesses/1"
        assert UtilsView.path_builder(event) == "/events/1"
    end

    test "path_builder/1 return values correspond with routes" do
        for_sale = Factory.insert(:for_sale)
        job = Factory.insert(:job)
        emergency_information = Factory.insert(:emergency_information)
        business = Factory.insert(:business)
        event = Factory.insert(:event)

        conn = build_conn()
            |> get(UtilsView.path_builder(for_sale))

        assert html_response(conn, 200)

        conn = build_conn()
            |> get(UtilsView.path_builder(job))

        assert html_response(conn, 200)

        conn = build_conn()
            |> get(UtilsView.path_builder(emergency_information))

        assert html_response(conn, 200)

        conn = build_conn()
            |> get(UtilsView.path_builder(event))

        assert html_response(conn, 200)

        conn = build_conn()
            |> get(UtilsView.path_builder(business))

        assert html_response(conn, 200)
    end

    test "flag_path_builder/1 returns expected values" do
        job = Factory.insert(:job)
        expected = "/flags/new?post_id=#{job.id}"
        assert UtilsView.flag_path_builder(job) == expected
    end
end
  