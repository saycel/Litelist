defmodule LitelistWeb.ForSaleView do
  use LitelistWeb, :view
  import LitelistWeb.FormHelpers
  import LitelistWeb.UtilsView

    @doc """
  This will return a struct with a route for where a form should submit to, the fields necessary for a form, and what the pop-over text should be for each field.  

  ## Parameters

    - resource: Pass through the post you are trying to build a form for.

  ## Examples

      iex> LitelistWeb.EventView.data(@current_sales_post)
      %{action: ... fields: build_fields(), resource: resource}
  
    Returns the struct the form partial requires
  
  """
  def data(resource) do
    if resource do
      %{action: "/sales/#{resource.id}", fields: build_fields(), resource: resource}
    else
      %{action: "/sales", fields: build_fields(), resource: resource}      
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
  		%{select: false, title: "DESCRIPTION", type: "text", po_body: "Describe the item you are trying to sell. Be detailed.", id: "post_description"},
  		%{select: false, title: "PRICE", type: "number", po_body: "How much are you selling this for?", id: "post_price"},
  		%{select: false, title: "CONTACT_INFO", type: "text", po_body: "How can someone who is interested in buying this item reach you?", id: "post_contact"},
  		# %{select: false, title: "URL", type: "text", po_body: "What URL do you want this post to be found at.  For instance: Ayashas-FORD-BRONCO.4sale.othernet or great-new-car.4sale.othernet", id: "post_url"}
  	]
  end
end


