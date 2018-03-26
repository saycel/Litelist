defmodule LitelistWeb.SharedView do
  use LitelistWeb, :view
  def getVal(resource,title) do
 	if resource != 0 do
  	  cond do
	   	title == "TITLE" ->
	    	resource.title
	    title == "DESCRIPTION" ->
			resource.description
	    title == "CONTACT_INFO" ->
			resource.contact_info
	    title == "ORGANIZATION_NAME" ->
			resource.organization_name
	    title == "URL" ->
			resource.url
		title == "COMPANY_NAME" ->
			resource.company_name
		title == "LOCATION" ->
			resource.location
		title == "PRICE" ->
			resource.price
		title == "SALARY" ->
			resource.salary
		title == "POSITION_NAME" ->
			resource.position_name
	  end
	 else
	 	""
	 end

  end

end
