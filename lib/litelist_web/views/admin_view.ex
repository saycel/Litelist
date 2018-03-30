defmodule LitelistWeb.AdminView do
    use LitelistWeb, :view

    def path_builder(resource) do
        case resource.type do
          "for_sale" -> "/sales/#{resource.id}"
          "job" -> "/jobs/#{resource.id}"
          "emergency_information" -> "/emergency_info/#{resource.id}"
          "business" -> "/businesses/#{resource.id}"
          "event" -> "/events/#{resource.id}"
        end
    end
end