defmodule Litelist.Discussions.Discussion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Discussions.Discussion


  schema "discussions" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
  end

  @doc false
  def changeset(%Discussion{} = discussion, attrs) do
    discussion
    |> cast(attrs, [:title, :description, :neighbor_id])
    |> unique_constraint(:title, message: "That title already exists. Try another one.")
    |> unique_constraint(:url, message: "That url already exists. Try another one.")
    |> foreign_key_constraint(:discussions, name: :discussions_neighbor_id_fkey)
    |> validate_required([:title, :description])
  end
end
