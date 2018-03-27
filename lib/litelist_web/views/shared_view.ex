defmodule LitelistWeb.SharedView do
  use LitelistWeb, :view
  @doc """
  getVal is used to map an inputted resource and a corresponding attribute to its saved value.  That sounds like a lot but its basically a utility for the edit form so that form fields prepopulate with the correct information.  


  ## Examples

      iex> LitelistWeb.SharedView(@EventPost,TITLE)
      My Cool Event
      iex> LitelistWeb.SharedView(@JobPost,PRICE)
      10.88 
  """
  @attributes %{
    "TITLE" => :title,
    "DESCRIPTION" => :description,
    "CONTACT_INFO" => :contact_info,
    "ORGANIZATION_NAME" => :organization_name,
    "URL" => :url,
    "COMPANY_NAME" => :company_name,
    "LOCATION" => :location,
    "PRICE" => :price,
    "SALARY" => :salary,
    "POSITION_NAME" => :position_name
  }

  def getVal(resource, attr) do
    if resource do
      mapped_resource = Map.from_struct(resource)
      mapped_resource[@attributes[attr]]
    else
      ""
    end
  end
end
