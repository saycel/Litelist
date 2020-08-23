defmodule Litelist.Auth.Neighbor do
  @moduledoc """
  Neighbor model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Auth.Neighbor
  alias Bcrypt

  schema "neighbors" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :admin, :boolean
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true


    timestamps()

    has_many :posts, Litelist.Posts.Post
    has_many :flags, Litelist.Moderation.Flag
    has_many :comments, Litelist.Comments.Comment

  end

  @doc false
  def changeset(%Neighbor{} = neighbor, attrs) do
    neighbor
    |> cast(attrs, [:username, :password, :password_confirmation, :admin, :first_name, :last_name])
    |> validate_confirmation(:password, message: "does not match password!")
    |> unique_constraint(:username, message: "That username already exists. Try another one.")
    |> validate_required([:username, :password])
    |> put_pass_hash()  
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: Bcrypt.hash_pwd_salt(password))
  end
    
  defp put_pass_hash(changeset), do: changeset
end
