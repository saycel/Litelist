defmodule Litelist.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Posts.Post


  schema "posts" do
    field :company_name, :string
    field :contact_info, :string
    field :description, :string
    field :end_date, :date
    field :location, :string
    field :neighbor_id, :integer
    field :position_name, :string
    field :price, :float
    field :salary, :string
    field :slug, :string
    field :start_date, :date
    field :title, :string
    field :type, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:type, :start_date, :end_date, :title, :description, :price, :slug, :url, :location, :contact_info, :salary, :position_name, :company_name, :neighbor_id])
    |> validate_required([:type, :start_date, :end_date, :title, :description, :price, :slug, :url, :location, :contact_info, :salary, :position_name, :company_name, :neighbor_id])
  end
end
