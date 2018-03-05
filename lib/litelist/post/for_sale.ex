defmodule Litelist.Post.ForSale do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Post.ForSale


  schema "for_sales" do
    field :contact_info, :string
    field :description, :string
    field :price, :float
    field :slug, :string
    field :title, :string

    belongs_to :neighbor, Litelist.Auth.Neighbor

    timestamps()
  end

  @doc false
  def changeset(%ForSale{} = for_sale, attrs) do
    for_sale
    |> cast(attrs, [:title, :description, :price, :contact_info, :slug, :neighbor_id])
    |> validate_required([:title, :description, :price, :contact_info, :neighbor_id])
  end
end
