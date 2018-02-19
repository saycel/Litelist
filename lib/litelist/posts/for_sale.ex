defmodule Litelist.Posts.ForSale do
  @moduledoc """
  ForSale model
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Posts.ForSale


  schema "for_sales" do
    field :contact_info, :string
    field :description, :string
    field :price, :float
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%ForSale{} = for_sale, attrs) do
    for_sale
    |> cast(attrs, [:title, :description, :price, :contact_info])
    |> validate_required([:title, :description, :price, :contact_info])
  end
end
