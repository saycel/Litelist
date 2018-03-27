defmodule LitelistWeb.FormHelpers do
  def get_form_data(type, resource \\ nil) do
    cond do
      type == "ForSale" ->
        LitelistWeb.ForSaleView.data(resource)

      type == "Job" ->
        LitelistWeb.JobView.data(resource)

      type == "Business" ->
        LitelistWeb.BusinessView.data(resource)

      type == "Emergency" ->
        LitelistWeb.EmergencyInformationView.data(resource)

      type == "Event" ->
        LitelistWeb.EventView.data(resource)
    end
  end
end
