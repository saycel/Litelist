defmodule Litelist.Discussions.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Discussions.Comment


  schema "discussion_comments" do
    field :body, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    belongs_to :discussion, Litelist.Discussions.Discussion
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :neighbor_id, :discussion_id])
    |> validate_required([:body, :neighbor_id, :discussion_id])
  end
end
