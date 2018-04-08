defmodule Litelist.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Images.Image


  schema "images" do
    field :image, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    belongs_to :post, Litelist.Posts.Post
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
