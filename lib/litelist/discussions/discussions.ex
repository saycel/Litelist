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

  alias Litelist.Discussions.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
