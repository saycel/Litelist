defmodule Litelist.Auth.Neighbor do
  @moduledoc """
  Neighbor model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Auth.Neighbor
  alias Comeonin.Bcrypt

  schema "neighbors" do
    field :password, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :admin, :boolean

    timestamps()

    has_many :posts, Litelist.Posts.Post
    has_many :flags, Litelist.Moderation.Flag
    has_many :comments, Litelist.Comments.Comment

  end

  @doc false
  def changeset(%Neighbor{} = neighbor, attrs) do
    neighbor
    |> cast(attrs, [:username, :password, :admin, :first_name, :last_name])
    |> unique_constraint(:username, message: "That username already exists. Try another one.")
    |> validate_required([:username, :password])
    |> put_pass_hash()  
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
    
  defp put_pass_hash(changeset), do: changeset
end
