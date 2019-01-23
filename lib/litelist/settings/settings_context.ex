defmodule Litelist.SettingsContext do
  @moduledoc """
  The Settings context.
  """
  alias Litelist.Settings.Settings

  import Ecto.Query, warn: false
  alias Litelist.Repo


  def get_settings do
    Repo.one(from x in Settings, order_by: [desc: x.id], limit: 1) || default_settings
  end

  def new_settings(attrs \\ %{}) do
    %Settings{}
    |> Settings.changeset(attrs)
    |> Repo.insert()
  end

  def default_settings do
    %{
        max_flagged_posts: Application.get_env(:litelist, :max_flagged_posts),
        allow_replies: Application.get_env(:litelist, :allow_replies),
        name: Application.get_env(:litelist, :name)
    }
  end
end