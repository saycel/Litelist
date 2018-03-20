defmodule Litelist.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Image


  schema "images" do
    field :url, :string

    timestamps()

    belongs_to :post, Litelist.Posts.Post
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
