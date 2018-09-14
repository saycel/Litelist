defmodule Litelist.Comments.Comment do
  @moduledoc """
  The Comment schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Comments.Comment

  schema "comments" do
    field :text, :string

    timestamps()

    belongs_to :post, Litelist.Posts.Post
    belongs_to :discussion, Litelist.Discussions.Discussion
    belongs_to :neighbor, Litelist.Auth.Neighbor

  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:text, :post_id, :discussion_id, :neighbor_id])
    |> validate_required([:text, :neighbor_id])
  end
end
