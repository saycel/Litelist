defmodule LitelistWeb.EventView do
  use LitelistWeb, :view
  import LitelistWeb.FormHelpers
  import LitelistWeb.UtilsView

  @doc """
  This will return a struct with a route for where a form should submit to, the fields necessary for a form, and what the pop-over text should be for each field.  

  ## Parameters

    - resource: Pass through the post you are trying to build a form for.

  ## Examples

      iex> LitelistWeb.EventView.data(@current_event_post)
      %{action: ..., fields: build_fields(), resource: resource}
  
    Returns the struct the form partial requires
  
  """
  def data(resource) do
    if resource do
      %{action: "/events/#{resource.id}", fields: build_fields(), resource: resource}
    else
      %{action: "/events", fields: build_fields(), resource: resource}
    end
  end
  @doc """
  This will return the proper form fields for the Business post


  ## Examples

      iex> LitelistWeb.build_fields()
      [%{...}]

      returns an array of structs that define the form field and the popover text. 
  """
  def build_fields() do
  	[
  		%{select: false, title: "TITLE", type: "text", po_body: "Choose a title for your job posting", id: "post_title"},
      %{select: true, title: "START_DATE", type: "select", po_body: "When do you need this position filled?", id: "post_start_date"},
      %{select: true, title: "END_DATE", type: "select", po_body: "When do you need this position filled?", id: "post_start_date"},
  		%{select: false, title: "DESCRIPTION", type: "text", po_body: "Describe the job you are offering. Be detailed.", id: "post_description"},
  		%{select: false, title: "LOCATION", type: "text", po_body: "Where are you located? Where does the work need to be performed?", id: "post_location"},
  		%{select: false, title: "CONTACT_INFO", type: "text", po_body: "How can someone who is interested in applying for this job reach you?", id: "post_contact"},
  		%{select: false, title: "URL", type: "text", po_body: "What URL do you want this post to be found at.  For instance: Ayashas-FORD-BRONCO.4sale.othernet or great-new-car.4sale.othernet", id: "post_url"}
  	]
  end
end
