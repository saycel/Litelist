defmodule Litelist.Auth.Neighbor do
  @moduledoc """
  Neighbor schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Auth.Neighbor
  alias Comeonin.Bcrypt

  schema "neighbors" do
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%Neighbor{} = neighbor, attrs) do
    neighbor
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> put_pass_hash()  
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
    
  defp put_pass_hash(changeset), do: changeset
end
