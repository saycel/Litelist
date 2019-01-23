defmodule Litelist.Settings.Settings do
  @moduledoc """
  The Settings schema.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Litelist.Settings.Settings

  schema "settings" do
    field :name, :string
    field :max_flagged_posts, :integer
    field :allow_replies, :boolean

    timestamps()
  end

    @doc false
    def changeset(%Settings{} = setting, attrs) do
      setting
      |> cast(attrs, [:name, :max_flagged_posts, :allow_replies])
      |> validate_required([:name, :max_flagged_posts, :allow_replies])
    end
end