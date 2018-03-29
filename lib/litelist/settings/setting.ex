defmodule Litelist.Settings.Setting do
  @moduledoc """
  The Setting schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Litelist.Settings.Setting


  schema "settings" do
    field :flag_count, :integer
    field :default_replyable, :boolean
    field :site_name, :string

    timestamps()

  end

  @doc false
  def changeset(%Setting{} = setting, attrs) do
    setting
    |> cast(attrs, [:flag_count, :default_replyable, :site_name])
  end
end
