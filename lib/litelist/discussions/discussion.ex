defmodule Litelist.Discussions.Discussion do
  @moduledoc """
  Discussion schema
  """
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
    has_many :comments, Litelist.Discussions.Comment
  end

  @doc false
  def changeset(%Discussion{} = discussion, attrs) do
    discussion
    |> cast(attrs, [:title, :description, :neighbor_id, :slug, :url])
    |> unique_constraint(:title, message: "That title already exists. Try another one.")
    |> unique_constraint(:url, message: "That url already exists. Try another one.")
    |> foreign_key_constraint(:discussions, name: :discussions_neighbor_id_fkey)
    |> validate_required([:title, :description, :url, :slug])
  end
end
