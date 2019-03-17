defmodule Litelist.Moderation do
  @moduledoc """
  The Moderation context.
  """


  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Moderation.Flag
  alias Litelist.Posts.Post

  @doc """
  Returns the list of flags.
  Posts are preloaded

  ## Examples

      iex> list_flags()
      [%Flag{}, ...]

  """
  def list_flags do
    Flag |> Repo.all() |> Repo.preload(:post)
  end

  @doc """
  Returns the list of pending flags in reverse order of when they were created (newest first).
  Posts are preloaded

  ## Examples

      iex> list_pending_flags()
      [%Flag{}, ...]

  """
  def list_pending_flags do
    query = from f in Flag, where: f.status == "pending", order_by: [desc: :inserted_at]
    query |> Repo.all() |> Repo.preload(:post)
  end

  @doc """
  Returns the list of archived flags in reverse order of when they were created (newest first).
  Posts are preloaded

  ## Examples

      iex> list_archived_flags()
      [%Flag{}, ...]

  """
  def list_archived_flags do
    query = from f in Flag, where: f.status != "pending", order_by: [desc: :inserted_at]
    query |> Repo.all() |> Repo.preload(:post)
  end

  @doc """
  Returns the list of flags created by the neighbor
  Posts are preloaded

  ## Examples

      iex> list_flags_by_neighbor(neighbor)
      [%Flag{}, ...]

  """
  def list_flags_by_neighbor(neighbor) do
    query = from f in Flag, where: f.neighbor_id == ^neighbor.id
    query |> Repo.all() |> Repo.preload(:post)
  end

  @doc """
  Returns the list of flags for posts created by the neighbor
  Posts are preloaded

  ## Examples

      iex> list_my_flagged_posts(neighbor)
      [%Flag{}, ...]

  """
  def list_my_flagged_posts(neighbor) do
    query = from f in Flag,
      join: p in Post, where: p.neighbor_id == ^neighbor.id
    query |> Repo.all() |> Repo.preload(:post)
  end

  @doc """
  Gets a single flag.
  Post is preloaded

  Raises `Ecto.NoResultsError` if the Flag does not exist.

  ## Examples

      iex> get_flag!(123)
      %Flag{}

      iex> get_flag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flag!(id), do: Flag |> Repo.get!(id) |> Repo.preload(post: :images) |> Repo.preload(:neighbor)

  @doc """
  Creates a flag.

  ## Examples

      iex> create_flag(%{field: value})
      {:ok, %Flag{}}

      iex> create_flag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flag(attrs \\ %{}) do
    %Flag{}
    |> Flag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flag.

  ## Examples

      iex> update_flag(flag, %{field: new_value})
      {:ok, %Flag{}}

      iex> update_flag(flag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flag(%Flag{} = flag, attrs) do
    flag
    |> Flag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Flag.

  ## Examples

      iex> delete_flag(flag)
      {:ok, %Flag{}}

      iex> delete_flag(flag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flag(%Flag{} = flag) do
    Repo.delete(flag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flag changes.

  ## Examples

      iex> change_flag(flag)
      %Ecto.Changeset{source: %Flag{}}

  """
  def change_flag(%Flag{} = flag) do
    Flag.changeset(flag, %{})
  end
end
