defmodule Litelist.Images.Image do
  import Ecto
  import Ecto.Changeset
  alias Litelist.Images.Image
  use Arc.Ecto.Schema
  use Ecto.Schema

  schema "images" do
    field :image, Litelist.ImageUploader.Type

    timestamps()

    belongs_to :post, Litelist.Posts.Post
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    IO.inspect "***"
    IO.inspect attrs
    image
    |> cast(attrs, [:image])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end
end
