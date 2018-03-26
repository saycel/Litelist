defmodule LitelistWeb.EventView do
  use LitelistWeb, :view
  import LitelistWeb.FormHelpers
  

  def data(resource) do
    if resource == 0 do
      %{action: "/events", fields: build_fields(),resource: resource}
    else
      %{action: "/events/#{resource.id}", fields: build_fields(),resource: resource}
    end
  end

  def build_fields() do
  	[
  		%{select: false, title: "TITLE",type: "text", po_body: "Choose a title for your job posting", id: "post_title"},
      %{select: true, title: "START_DATE",type: "select", po_body: "When do you need this position filled?", id: "post_start_date"},
      %{select: true, title: "END_DATE",type: "select", po_body: "When do you need this position filled?", id: "post_start_date"},
  		%{select: false, title: "DESCRIPTION",type: "text", po_body: "Describe the job you are offering. Be detailed.", id: "post_description"},
  		%{select: false, title: "LOCATION",type: "text", po_body: "Where are you located? Where does the work need to be performed?", id: "post_location"},
  		%{select: false, title: "CONTACT_INFO",type: "text", po_body: "How can someone who is interested in applying for this job reach you?", id: "post_contact"},
  		%{select: false, title: "URL",type: "text", po_body: "What URL do you want this post to be found at.  For instance: Ayashas-FORD-BRONCO.4sale.othernet or great-new-car.4sale.othernet", id: "post_url"}

  	]
  end
end
