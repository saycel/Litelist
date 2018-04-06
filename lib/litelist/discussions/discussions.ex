defmodule Litelist.Discussions do
  @moduledoc """
  The Discussions context.
  """

  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Discussions.Discussion

  @doc """
  Returns the list of discussions.

  ## Examples

      iex> list_discussions()
      [%Discussion{}, ...]

  """
  def list_discussions do
    Repo.all(Discussion)
  end

  @doc """
  Returns the list of discussions created by the neighbor.

  ## Examples

      iex> list_discussions()
      [%Discussion{}, ...]

  """
  def list_discussions_by_neighbor(neighbor) do
    Repo.all(from d in Discussion, where: d.neighbor_id == ^neighbor.id)
  end

  @doc """
  Gets a single discussion.

  Raises `Ecto.NoResultsError` if the Discussion does not exist.

  ## Examples

      iex> get_discussion!(123)
      %Discussion{}

      iex> get_discussion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discussion!(id), do: Repo.get!(Discussion, id)

  @doc """
  Creates a discussion.

  ## Examples

      iex> create_discussion(%{field: value})
      {:ok, %Discussion{}}

      iex> create_discussion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discussion(attrs \\ %{}) do
    %Discussion{}
    |> Discussion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a discussion.

  ## Examples

      iex> update_discussion(discussion, %{field: new_value})
      {:ok, %Discussion{}}

      iex> update_discussion(discussion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discussion(%Discussion{} = discussion, attrs) do
    discussion
    |> Discussion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Discussion.

  ## Examples

      iex> delete_discussion(discussion)
      {:ok, %Discussion{}}

      iex> delete_discussion(discussion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discussion(%Discussion{} = discussion) do
    Repo.delete(discussion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discussion changes.

  ## Examples

      iex> change_discussion(discussion)
      %Ecto.Changeset{source: %Discussion{}}

  """
  def change_discussion(%Discussion{} = discussion) do
    Discussion.changeset(discussion, %{})
  end
end
