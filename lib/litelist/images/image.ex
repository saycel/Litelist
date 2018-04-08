defmodule Litelist.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Images.Image


  schema "images" do
    field :image, :string
    field :post_id, :id

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor

  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
