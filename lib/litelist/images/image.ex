defmodule Litelist.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Images.Image


  schema "images" do
    field :type, :string
    field :post_id, :id
    field :neighbor_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
