defmodule Litelist.Moderation.Flag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Moderation.Flag


  schema "flags" do
    field :admin_response, :string
    field :description, :string
    field :status, :string
    field :type, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    belongs_to :post, Litelist.Posts.Post

  end

  @doc false
  def changeset(%Flag{} = flag, attrs) do
    flag
    |> cast(attrs, [:type, :description, :status, :admin_response, :post_id, :neighbor_id])
    |> validate_required([:type, :description, :status, :post_id])
    |> validate_subset(:type, ["Inappropriate", "Incorrect information", "Legal concerns", "Abusive"])
    |> validate_subset(:status, ["pending", "post_removed", "post_restored"])

  end
end
