defmodule LitelistWeb.SharedView do
  use LitelistWeb, :view

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
