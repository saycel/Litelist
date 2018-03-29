defmodule Litelist.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Settings.Setting

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Post{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end


  @doc """
  Returns the list of settings based on the type of post (eg. for_sale, job).

  ## Examples

      iex> list_settings_by_type(type)
      [%Setting{}, ...]

  """
  def list_settings_by_type(type) do
    Repo.all(from s in Setting, where: s.type == ^type)
  end



  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

 
  def change_setting(%Setting{} = setting) do
    Setting.changeset(setting, %{})
  end

  def get_global_setting do
    Repo.one(Setting)
  end
end
