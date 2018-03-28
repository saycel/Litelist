defmodule Litelist.Discussions.Discussion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Discussions.Discussion


  schema "discussions" do
    field :description, :string
    field :title, :string
    field :slug, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    has_many :comments, Litelist.Discussions.Comment
  end

  @doc false
  def changeset(%Discussion{} = discussion, attrs) do
    discussion
    |> cast(attrs, [:title, :description, :slug, :neighbor_id])
    |> foreign_key_constraint(:discussions, name: :discussions_neighbor_id_fkey)
    |> validate_required([:title, :description, :slug, :neighbor_id])
  end
end
