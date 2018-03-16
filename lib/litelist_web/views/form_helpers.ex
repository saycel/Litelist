defmodule LitelistWeb.FormHelpers do
  alias LitelistWeb.Form

  def get_form_data(type) do
  	
	cond do
	   	type == "ForSale" ->
	    	LitelistWeb.ForSaleView.data([])
	    type == "Job" ->
	    	LitelistWeb.JobView.data([])
	   	type == "Business" ->
	    	LitelistWeb.BusinessView.data([])
	    type == "Emergency" ->
	    	LitelistWeb.EmergencyInformationView.data([])
	    type == "Events" ->
	    	LitelistWeb.EventView.data([])
	    		
	 end

  end

end