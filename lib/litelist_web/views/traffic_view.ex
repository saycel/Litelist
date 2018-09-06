defmodule LitelistWeb.TrafficView do
  use LitelistWeb, :view
  import LitelistWeb.FormHelpers
  import LitelistWeb.UtilsView

  @doc """
  This will return a struct with a route for where a form should submit to, the fields necessary for a form, and what the pop-over text should be for each field.  

  ## Parameters

    - resource: Pass through the post you are trying to build a form for.

  ## Examples

      iex> LitelistWeb.jobs.data(@current_jobs_post)
      %{action: ..., fields: build_fields(), resource: resource}
  
    Returns the struct the form partial requires
  
  """
  def data(resource) do
    if resource do
      %{image: true, action: "/traffics/#{resource.id}", fields: build_fields(), resource: resource}
    else
      %{image: true, action: "/traffics", fields: build_fields(), resource: resource}
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
  		%{select: false, title: "DESCRIPTION", type: "text", po_body: "Describe the job you are offering. Be detailed.", id: "post_description"},
  		%{select: false, title: "LOCATION", type: "text", po_body: "Where are you located? Where does the work need to be performed?", id: "post_location"},
  	]
  end
end
