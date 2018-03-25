defmodule LitelistWeb.DashboardViewTest do
    use LitelistWeb.ConnCase, async: true

    alias LitelistWeb.DashboardView

    test "path_builder/1 returns expected values" do
        for_sale = %{type: "for_sale", id: 1}
        job = %{type: "job", id: 1}
        emergency_information = %{type: "emergency_information", id: 1}
        business = %{type: "business", id: 1}
        event = %{type: "event", id: 1}

        assert DashboardView.path_builder(for_sale) == "/sales/1"
        assert DashboardView.path_builder(job) == "/jobs/1"
        assert DashboardView.path_builder(emergency_information) == "/emergency_info/1"
        assert DashboardView.path_builder(business) == "/businesses/1"
        assert DashboardView.path_builder(event) == "/events/1"
    end
end
  