defmodule Litelist.Posts.Post do
  @moduledoc """
  The Posts schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Posts.Post
  alias Litelist.Images.Image


  schema "posts" do
    field :company_name, :string
    field :contact_info, :string
    field :description, :string
    field :end_date, :date
    field :end_time, :utc_datetime
    field :location, :string
    field :organization_name, :string
    field :position_name, :string
    field :price, :float
    field :salary, :string
    field :slug, :string
    field :start_date, :date
    field :start_time, :utc_datetime
    field :title, :string
    field :type, :string
    field :url, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    has_many :flags, Litelist.Moderation.Flag
    has_many :images, Litelist.Images.Image
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    IO.inspect "*****"
    IO.inspect post
    IO.inspect attrs
    IO.inspect "*****"

    post
    |> cast(attrs, [:type, :title, :description, :price, :slug, :url, :location, :contact_info, :salary, :position_name, :company_name, :neighbor_id, :start_date, :end_date, :start_time, :end_time, :organization_name])
    |> cast_assoc(:images, required: false, with: &Image.changeset/2)
    |> unique_constraint(:url, message: "That URL already exists. Try another one.")
    |> foreign_key_constraint(:posts, name: :posts_neighbor_id_fkey)
    |> validate_required([:type, :title, :description, :slug, :url, :neighbor_id])
  end
end
