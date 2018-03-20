defmodule Litelist.Posts.Post do
  @moduledoc """
  The Posts schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Posts.Post


  schema "posts" do
    field :company_name, :string
    field :contact_info, :string
    field :description, :string
    field :end_date, :date
    field :end_time, :utc_datetime
    field :location, :string
    field :organization_name, :string
    field :position_name, :string
    field :price, :float
    field :salary, :string
    field :slug, :string
    field :start_date, :date
    field :start_time, :utc_datetime
    field :title, :string
    field :type, :string
    field :url, :string

    timestamps()

    belongs_to :neighbor, Litelist.Auth.Neighbor
    has_many :images, Litelist.Image
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:type, :title, :description, :price, :slug, :url, :location, :contact_info, :salary, :position_name, :company_name, :neighbor_id, :start_date, :end_date, :start_time, :end_time, :organization_name])
    |> unique_constraint(:url, message: "That URL already exists. Try another one.")
    |> validate_required([:type, :title, :description, :slug, :url, :neighbor_id])
  end
end
