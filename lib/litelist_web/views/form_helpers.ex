defmodule LitelistWeb.FormHelpers do
  @moduledoc """
  Form Helpers are how LiteList can use a single form for all of its resources. 
  """

  @doc """
  Determines what resource is being built.  

  ## Parameters

    - type: The Type of Post being created or edited. 
    - resource: Optional. If its an edit form, pass through the object from the controller to the view to this helper.

  ## Examples

      iex> LitelistWeb.FormHelpers.get_form_data("ForSale",@current_post)
      
  """
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

      type == "Traffic" ->
        LitelistWeb.TrafficView.data(resource)

      type == "Discussion" ->
        LitelistWeb.DiscussionView.data(resource)
    end
  end
end
