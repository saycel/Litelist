defmodule Litelist.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Comments.Comment


  schema "comments" do
    field :text, :string
    field :post_id, :id
    field :discussion_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
