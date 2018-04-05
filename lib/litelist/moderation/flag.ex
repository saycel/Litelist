defmodule Litelist.Moderation.Flag do
  @moduledoc """
  Flag schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Moderation.Flag

  @statuses [
    "pending",
    "post_removed",
    "post_restored"
  ]

  @types [
    "Inappropriate",
    "Incorrect information",
    "Legal concerns",
    "Abusive"
  ]

  @default_type "pending"

  def get_statuses(), do: @statuses
  def get_types(), do: @types
  def get_default_type(), do: @default_type

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
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:status, @statuses)

  end
end
