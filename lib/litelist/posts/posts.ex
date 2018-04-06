defmodule Litelist.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Litelist.Repo

  alias Litelist.Posts.Post
  alias Litelist.Posts.Search
  alias Litelist.Moderation.Flag

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Returns the list of posts based on the type of post (eg. for_sale, job).

  ## Examples

      iex> list_posts_by_type(type)
      [%Post{}, ...]

  """
  def list_posts_by_type(type) do
    Repo.all(from p in Post, where: p.type == ^type)
  end

  @doc """
  Returns the list of posts created by a given neighbor.

  ## Examples

      iex> list_posts_by_type(type)
      [%Post{}, ...]

  """
  def list_posts_by_neighbor(neighbor) do
    Repo.all(from p in Post, where: p.neighbor_id == ^neighbor.id)
  end

  @doc """
  Returns the list of posts with a given search query.

  ## Examples

      iex> list_posts_by_search_term(search_term)
      [%Post{}, ...]

  """
  def list_posts_by_search_term(search_term) do
    query = Post
      |> Search.run(search_term)
    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Deletes all Posts created by a given Neighbor.

  ## Examples
      iex> delete_post_by_neighbor(neighbor)
  """
  def delete_all_by_neighbor(neighbor) do
    Repo.delete_all(from p in Post, where: p.neighbor_id == ^neighbor.id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  @doc """
  Deletes all posts returned from Posts.get_expired_posts_query
  """
  def delete_expired_posts() do
    Repo.delete_all(get_expired_posts_query())
  end

  # @doc """
  # Soft delete all posts returned from Posts.get_expired_posts_query
  # """
  # def soft_delete_expired_posts() do
  #   expired_posts = Repo.all(get_expired_posts_query())
  #   # Run in a transaction
  # end

  @doc """
  returns the query that will return expired posts
  """
  # credo:disable-for-lines:15
  def get_expired_posts_query() do
    time_limit = 30
    now = Timex.now
    today = Timex.today
    date_cutoff = Timex.shift(now, days: -time_limit)

    from p in Post,
      where: p.inserted_at < ^date_cutoff and is_nil(p.end_time) and is_nil(p.end_date) or p.end_date < ^today,
      or_where: p.inserted_at < ^date_cutoff and is_nil(p.end_date) and is_nil(p.end_time) or p.end_time < ^now,
      or_where: p.inserted_at < ^date_cutoff and p.end_time < ^now and p.end_date < ^today,
      or_where: p.inserted_at < ^date_cutoff and is_nil(p.end_time) and is_nil(p.end_date),
      or_where: p.end_time < ^now and is_nil(p.end_time),
      or_where: p.end_date < ^today and is_nil(p.end_date),
      or_where: p.end_time < ^now and p.end_date < ^today
  end

  @doc """
  Ecto query that returns how many pending flags a post has
  iex> get_pending_flag_count(post)
  2
  """
  def get_pending_flag_count(post) do
    query = from f in Flag,
      where: f.post_id == ^post.id,
      where: f.status == "pending"

    Repo.aggregate(query, :count, :id)
  end
end
