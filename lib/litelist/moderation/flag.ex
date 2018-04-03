defmodule Litelist.Moderation.Flag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Moderation.Flag


  schema "flags" do
    field :admin_response, :string
    field :description, :string
    field :status, :string
    field :type, :string
    field :post_id, :id
    field :neighbor_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Flag{} = flag, attrs) do
    flag
    |> cast(attrs, [:type, :description, :status, :admin_response])
    |> validate_required([:type, :description, :status, :admin_response])
  end
end
