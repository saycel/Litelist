defmodule LitelistWeb.DiscussionView do
  use LitelistWeb, :view
    import LitelistWeb.UtilsView
    import LitelistWeb.FormHelpers

  def data(resource) do
    if resource do
      %{image: false, action: "/discussions/#{resource.id}", fields: build_fields(), resource: resource}
    else
      %{image: false, action: "/discussions", fields: build_fields(), resource: resource}      
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
  		%{select: false, title: "TITLE", type: "text", po_body: "Choose a title for your post", id: "post_title"},
  		%{select: false, title: "DESCRIPTION", type: "text", po_body: "Describe the item you are trying to sell. Be detailed.", id: "post_description"}
  
  	]
  end
end

