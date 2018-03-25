defmodule Litelist.Discussions.Discussion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Discussions.Discussion


  schema "discussions" do
    field :description, :string
    field :title, :string
    field :neighbor_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Discussion{} = discussion, attrs) do
    discussion
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
