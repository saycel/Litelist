defmodule LitelistWeb.FormHelpers do
  alias LitelistWeb.Form

  def get_form_data(type) do
  	if type == "ForSale" do
  		LitelistWeb.ForSaleView.data([])
  	end
  	if type == "Job" do
  		LitelistWeb.JobView.data([])
  	end
  end

 
end