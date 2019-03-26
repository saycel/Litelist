defmodule Litelist.Posts.PostType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "post_types" do
    field :name, :string
    field :form_data, :map

    timestamps()
  end

  @doc false
  def changeset(post_type, attrs) do
    post_type
    |> cast(attrs, [:name, :form_data])
    |> validate_required([:name, :form_data])
  end
end
